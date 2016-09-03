class Farmer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_secure_token :referral_token
  before_create :ensure_referral_token, :check_referral
  belongs_to :referral_user, polymorphic: true

  validates_presence_of :first_name, :last_name

  attr_accessor :referred_by_token

  protected

  def ensure_referral_token
    return if referral_token?
    regenerate_referral_token
  end

  def check_referral
    return if referred_by_token.nil?
    if user = Worker.find_by_referral_token(referred_by_token) || Farmer.find_by_referral_token(referred_by_token)
      self.referral_user = user
    end
  end
end
