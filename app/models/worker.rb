class Worker < ActiveRecord::Base
  include Filterable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_and_belongs_to_many :skills, -> { uniq }
  has_and_belongs_to_many :job_categories, -> { uniq }
  has_and_belongs_to_many :jobs, -> { uniq }
  has_many                :unavailabilities
  has_and_belongs_to_many :locations, -> { uniq }
  has_many                :previous_employers
  has_many                :educations
  has_many                :certificates
  has_secure_token        :referral_token
  has_attached_file       :profile_photo, :styles => { :display => "200x200#" }
  belongs_to              :referral_user, polymorphic: true

  scope :locations, -> (location_ids) { joins(:locations).where(locations: { id: location_ids }) }
  scope :job_categories, -> (job_category_ids) { joins(:job_categories).where(job_categories: { id: job_category_ids }) }
  scope :skills, -> (skill_ids) { joins(:skills).where(skills: { id: skill_ids }) }
  scope :unavailability, -> (start_date, end_date) { where(id: Unavailability.in_range(start_date, end_date).pluck(:worker_id).uniq) }
  scope :availability, -> (start_date, end_date) { where.not(id: Worker.unavailability(start_date, end_date).pluck(:id) ) }

  validates_attachment_content_type :profile_photo, :content_type => /\Aimage\/.*\Z/
  validates_presence_of             :first_name, :last_name

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

   def full_name
    [first_name, last_name].reject { |el| el.empty? }.join(" ")
   end

  protected

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
