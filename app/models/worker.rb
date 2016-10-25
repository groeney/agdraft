class Worker < ActiveRecord::Base
  include Recommendable, Filterable
  acts_as_token_authenticatable
  include Filterable
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

  attr_accessor :referred_by_token

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
    # TODO implement properly with review model etc...
    rand(1..5)
  end

  def recommended_jobs
    Job.recommend({ skills: skill_ids, job_categories: job_category_ids },
                  job_workers.pluck(:job_id))
  end

  def job_history
    job_workers.where({ state: "hired" }).map{ |job_worker| job_worker.job }
  end

  def employers
    Farmer.where({ id: job_history.map{ |job| job.farmer_id }.flatten })
  end

  def can_review(farmer_id)
    employers.where({ id: farmer_id }).exists?
  end

  def has_reviewed_farmer(farmer_id)
    reviews_by.where({ reviewee_id: farmer_id, reviewee_type: "Farmer" }).exists?
  end

  def reviews
    query = "(reviewee_type = :worker_type and reviewee_id = :worker_id) or (reviewer_type = :worker_type and reviewer_id = :worker_id)"
    Review.where(query, worker_id: id, worker_type: "Worker")
  end

  def reviews_by
    query = "reviewer_type = :worker_type and reviewer_id = :worker_id"
    Review.where(query, worker_id: id, worker_type: "Worker")
  end

  def reviews_of
    query = "reviewee_type = :worker_type and reviewee_id = :worker_id"
    Review.where(query, worker_id: id, worker_type: "Worker")
  end

  def profile_completeness
    attrs = slice :has_own_transport, :tax_file_number, :mobile_number,
                  :nationality, :dob, :description, :passport_number, :abn,
                  :grew_up_on_farm, :has_own_accommodation
    rand(30..100)
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
