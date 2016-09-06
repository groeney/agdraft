class Farmer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_secure_token :referral_token
  has_attached_file :profile_photo, :styles => { :display => "200x200#" }
  has_attached_file :cover_photo, :styles => { :display => "1400x300#" }
  before_create :ensure_referral_token, :set_referral_user
  belongs_to :referral_user, polymorphic: true
  belongs_to :location
  validates_attachment_content_type :profile_photo, :content_type => /\Aimage\/.*\Z/
  validates_presence_of :first_name, :last_name

  attr_accessor :referred_by_token

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
