class Worker < ActiveRecord::Base
  include Recommendable, Filterable, Rails.application.routes.url_helpers
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_and_belongs_to_many :skills, -> { uniq }
  has_and_belongs_to_many :job_categories, -> { uniq }
  has_and_belongs_to_many :jobs, -> { uniq }
  has_many                :unavailabilities
  has_and_belongs_to_many :locations, -> { uniq }
  has_many                :previous_employers
  has_many                :educations
  has_many                :certificates
  has_many                :job_workers
  has_many                :notifications, as: :resource, dependent: :destroy
  has_many                :recommendations, as: :user, dependent: :destroy
  has_secure_token        :referral_token
  has_attached_file       :profile_photo, :styles => { :display => "200x200#" }, :default_url => "/assets/missing_worker_profile_photo.png"
  belongs_to              :referral_user, polymorphic: true

  scope :locations, -> (location_ids) { joins(:locations).where(locations: { id: location_ids }) }
  scope :job_categories, -> (job_category_ids) { joins(:job_categories).where(job_categories: { id: job_category_ids }) }
  scope :skills, -> (skill_ids) { joins(:skills).where(skills: { id: skill_ids }) }
  scope :unavailability, -> (start_date, end_date) { where(id: Unavailability.in_range(start_date, end_date).pluck(:worker_id).uniq) }
  scope :availability, -> (start_date, end_date) { where.not(id: Worker.unavailability(start_date, end_date).pluck(:id) ) }
  scope :visibles, -> () { where(verified: true, hidden: false) }

  validates_attachment_content_type :profile_photo, :content_type => /\Aimage\/.*\Z/
  validates_presence_of             :first_name

  before_create :ensure_referral_token, :set_referral_user
  after_create :notify_referrer, :signup_notifications

  attr_accessor :referred_by_token

  def notify_referrer
    if referral_user
      Notification.create(resource: referral_user,
                          action_path: worker_path(id),
                          thumbnail: profile_photo,
                          header: "Kudos! #{full_name} used your referral token to sign up.",
                          description: "Thank you for referring your friend."
                          )
    end
  end

  def signup_notifications
    Notification.create(resource: self,
                        action_path: worker_previous_employers_path,
                        thumbnail: profile_photo,
                        header: "Action step: previous employer",
                        description: "Add a previous employer so we can verify your account!"
                        )

    Notification.create(resource: self,
                        action_path: worker_profile_photo_path,
                        thumbnail: profile_photo,
                        header: "Action step: profile photo",
                        description: "Increase your chances of finding work by adding a profile photo."
                        )

    Notification.create(resource: self,
                        action_path: worker_locations_path,
                        thumbnail: profile_photo,
                        header: "Action step: locations",
                        description: "Increase your chances of finding work by selecting some work locations."
                        )

    Notification.create(resource: self,
                        action_path: worker_qualifications_path,
                        thumbnail: profile_photo,
                        header: "Action step: qualifications",
                        description: "Increase your chances of finding work by adding your qualifications."
                        )

    Notification.create(resource: self,
                        action_path: worker_extra_details_path,
                        thumbnail: profile_photo,
                        header: "Action step: personal info",
                        description: "Increase your chances of finding work by filling in your personal information."
                        )
  end

  def eligible_job_categories
    self_job_categories = job_categories
    JobCategory.all.reject { |jc| self_job_categories.include? jc }
  end

  def eligible_skills
    self_skills = skills
    job_categories.map { |jc| jc.skills }.flatten.uniq.reject do |skill|
      self_skills.include? skill
    end
  end

  def country_name
    country = self.nationality
    ISO3166::Country[country]
  end

  def location_name
    return "" unless location = locations.first
    [location.region, location.state].reject { |el| el.empty? }.join(", ")
  end

  def full_name
    [first_name, last_name].reject { |el| el.empty? }.join(" ")
  end

  def filter_rating(filter_params)
    raw_rating = 0
    filter_params.slice(:job_categories, :skills, :locations).each do |key, ids|
      raw_rating += self.public_send(key).where({ id: ids }).count if ids.present?
    end
    raw_rating
  end

  def review_rating
    if reviews_of.empty?
      0
    else
      reviews_of.average(:rating).ceil 
    end
  end

  def job_recommendations
    results = self.recommendations.where({ blocked: false, resource_type: "Job" })
    if results.count < 5
      new_recommendations = recommend_jobs(5 - results.count)
      new_recommendations.each do |job|
        results |= [self.recommendations.create({ resource: job })]
      end
    end
    results
  end

  def is_job_applyable(job)
    job_worker = job_workers.find_by({ job_id: job.id })
    !job_worker || job_worker.invited? || job_worker.new?
  end

  def recommend_jobs(size = 5)
    blocked_recommendations = self.recommendations.pluck(:resource_id)
    applied_jobs = job_workers.where.not({ state: "invited" }).pluck(:job_id)
    Job.recommend({ skills: skill_ids, job_categories: job_category_ids },
                  blocked_recommendations |= applied_jobs, size)
  end

  def job_history(farmer = nil)
    job_workers_local = self.job_workers.where({ state: "hired" })
    if farmer
      job_workers_local = job_workers_local.where({ job_id: farmer.jobs.pluck(:id) })
    end
    job_workers_local.map{ |job_worker| job_worker.job }
  end

  def pending_review_jobs(farmer = nil)
    reviewed_jobs = self.reviews_of.pluck(:job_id)
    self.job_history(farmer).reject { |job| reviewed_jobs.include? job.id }
  end

  def job_offers
    job_workers.where({ state: ["hired", "shortlisted"] }).map{ |job_worker| job_worker.job }
  end

  def job_applications
    job_workers.where({ state: ["interested"] }).map{ |job_worker| job_worker.job }
  end

  def employers
    Farmer.where({ id: job_history.map{ |job| job.farmer_id }.flatten })
  end

  def can_review(farmer_id)
    employers.where({ id: farmer_id }).exists? && reviews_by.where(reviewee_id: farmer_id).empty?
  end

  def has_reviewed_farmer(farmer_id)
    Review.where(reviewee_id: farmer_id, reviewee_type: "Farmer", reviewer_id: id, reviewer_type: "Worker" ).exists?
  end

  def reviews
    query = "(reviewee_type = :worker_type and reviewee_id = :worker_id) or (reviewer_type = :worker_type and reviewer_id = :worker_id)"
    Review.where(query, worker_id: id, worker_type: "Worker")
  end

  def reviews_by
    Review.where(reviewer_id: id, reviewer_type: "Worker")
  end

  def reviews_of
    Review.where(reviewee_id: id, reviewee_type: "Worker", approved: true)
  end

  def profile_completeness
    attrs = slice :tax_file_number, :mobile_number, :passport_number,
                  :nationality, :dob, :description, :abn, :profile_photo,
                  :email, :first_name, :last_name
    values = attrs.values | [previous_employers, locations, job_categories, skills]
    values.reject{ |v| v.blank? }.count*100/values.count
  end

  def australian?
    nationality.try(:include?, "Australia")
  end

  def unreviewed_jobs
    hired_job_ids = job_workers.where({ state: ["hired"] }).map {|el| el.job_id }
    reviewed_job_ids = reviews_by.map {|el| el.job_id }    
    unreviewed_job_ids = hired_job_ids - reviewed_job_ids
    return unreviewed_job_ids.map {|id| Job.find(id)}
  end

  protected

  def skill_ids
    skills.pluck(:id)
  end

  def job_category_ids
    job_categories.pluck(:id)
  end

  def ensure_referral_token
    return if referral_token?
    regenerate_referral_token
  end

  def set_referral_user
    return if referred_by_token.nil?
    if user = Worker.find_by_referral_token(referred_by_token) || Farmer.find_by_referral_token(referred_by_token)
      self.referral_user = user
    end
  end
end
