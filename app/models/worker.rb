class Worker < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_secure_token :referral_token
  before_save :ensure_referral_token
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :job_categories

  def ensure_referral_token
    return if referral_token?
    regenerate_referral_token
  end
end
