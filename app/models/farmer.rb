class Farmer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_secure_token :referral_token
  has_attached_file :profile_photo, :styles => { :display => "200x200#" }, :default_url => "/assets/missing_farmer_profile_photo.png"
  has_attached_file :cover_photo, :styles => { :display => "1400x300#" }, :default_url => "/assets/missing_farmer_cover_photo.jpg"
  before_create :ensure_referral_token, :set_referral_user
  belongs_to :referral_user, polymorphic: true
  belongs_to :location
  has_many :jobs
  has_many :payment_audtis
  validates_attachment_content_type :profile_photo, :content_type => /\Aimage\/.*\Z/
  validates_presence_of :first_name, :last_name
  validate :credit_cannot_be_negative

  attr_accessor :referred_by_token

  def update_stripe_customer_source(token)
    begin
      customer = Stripe::Customer.create(
        :description => "Customer for #{current_farmer.email}",
        :email => email,
        :source => token
      )
    rescue
      return false
    end

    stripe_customer_id = customer.id
    stripe_deliquent = customer.deliquent
    save
  end

  def has_valid_payment?
    !stripe_customer_id.nil? && !stripe_delinquent
  end

  def jobs_for_worker(worker_id)
    jobs.where(published: true).map{|j| {job: j, invited: !JobWorker.where(job_id: j.id, worker_id: worker_id).empty? } }
  end

  def full_name
    [first_name, last_name].reject { |el| el.empty? }.join(" ")
  end

  def rating
    rand(2..5)
  end

  protected

  def credit_cannot_be_negative
    errors.add(:credit, "cannot be a negative value") if credit.negative?
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
