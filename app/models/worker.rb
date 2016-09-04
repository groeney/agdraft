class Worker < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_secure_token :referral_token
  has_and_belongs_to_many :skills, -> { uniq }
  has_and_belongs_to_many :job_categories, -> { uniq }
  before_create :ensure_referral_token, :set_referral_user
  belongs_to :referral_user, polymorphic: true
  validates_presence_of :first_name, :last_name

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
