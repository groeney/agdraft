class Farmer < ActiveRecord::Base
  include Rails.application.routes.url_helpers, Devise::Controllers::UrlHelpers
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_secure_token :referral_token
  has_attached_file :profile_photo, :styles => { :display => "200x200#" }, :default_url => "/assets/missing_farmer_profile_photo.png"
  has_attached_file :cover_photo, :styles => { :display => "1400x300#" }, :default_url => "/assets/missing_farmer_cover_photo.jpg"
  before_create :ensure_referral_token, :set_referral_user
  belongs_to :referral_user, polymorphic: true
  belongs_to :location
  has_many :jobs
  has_many :payment_audtis
  has_many :notifications, as: :resource, dependent: :destroy
  has_many :recommendations, as: :user, dependent: :destroy
  validates_attachment_content_type :profile_photo, :content_type => /\Aimage\/.*\Z/
  validates_presence_of :first_name, :last_name
  validate :credit_cannot_be_negative

  after_create :analytics # Must fire before other callbacks
  after_create :referred_logic, :signup_notifications
  after_update :send_notification_after_change, :identify_thyself

  attr_accessor :referred_by_token

  def analytics_id
    "Farmer##{self.id}"
  end

  def referred_logic
    if referral_user
      Notification.create(resource: referral_user,
                          action_path: worker_path(id),
                          thumbnail: profile_photo,
                          header: "Kudos! #{full_name} used your referral token to sign up.",
                          description: "Thank you for referring your friend."
                          )

      Analytics.track(
        user_id: self.analytics_id,
        event: "Referred User",
        properties: {
          referral_user_id: referral_user.analytics_id,
          referral_user_email: referral_user.email
          }
        )

      AdminMailer.referred_user(self, referral_user).deliver
    end
  end

  def send_notification_after_change
    if self.credit_changed?
      Notification.create(resource: self,
                          action_path: farmer_dashboard_path,
                          thumbnail: profile_photo,
                          header: "Credits added!",
                          description: "You now have #{self.credit} credits on your account."
                          )
    end
  end

  def analytics
    identify_thyself
    Analytics.track(
      user_id: self.analytics_id,
      event: "Signup")
  end

  def identify_thyself
    Analytics.identify(
      user_id: self.analytics_id,
      traits: {
        email: self.email,
        user_type: "Farmer",
        created_at: self.created_at,
        phone: self.contact_number,
        title: self.business_name,
        description: self.business_description
      }
    )
  end

  def signup_notifications
    Notification.create(resource: self,
                        action_path: edit_farmer_farmer_path(self.id),
                        thumbnail: profile_photo,
                        header: "Action step: farm details",
                        description: "Increase your chances of attracting workers by adding details about your farm."
                        )

    Notification.create(resource: self,
                        action_path: farmer_profile_photo_path,
                        thumbnail: profile_photo,
                        header: "Action step: profile photo",
                        description: "Increase your chances of attracting workers by adding a profile photo."
                        )

    Notification.create(resource: self,
                        action_path: farmer_cover_photo_path,
                        thumbnail: profile_photo,
                        header: "Action step: cover photo",
                        description: "Increase your chances of attracting workers by adding a cover photo."
                        )

    Notification.create(resource: self,
                        action_path: farmer_jobs_path,
                        thumbnail: profile_photo,
                        header: "Action step: post a job",
                        description: "Post a job to attract workers to you farm!"
                        )
  end

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
    jobs.where(published: true)
        .map{ |j| { job: j, invited: JobWorker.where(job_id: j.id, worker_id: worker_id)
                                              .exists? } }
  end

  def employees
    Worker.where({ id: published_jobs.map{ |job| job.hired_job_workers.pluck(:worker_id) }.flatten })
  end

  def can_review(worker_id)
    employees.where({ id: worker_id }).exists? &&
      Worker.find(worker_id).pending_review_jobs(self).present?
  end

  def has_reviewed_worker(worker_id)
    reviews_by.where({ reviewee_id: worker_id, reviewee_type: "Worker" }).exists?
  end

  def full_name
    [first_name, last_name].reject { |el| el.empty? }.join(" ")
  end

  def review_rating
    if reviews_of.empty?
      0
    else
      reviews_of.average(:rating).ceil
    end
  end

  def recommended_workers
    recommend = jobs.map{ |job| job.recommended_workers }.flatten.uniq
    (recommend.any? ? recommend : Worker.all).sample 5
  end

  def published_jobs
    jobs.where({ published: true })
  end

  def reviews
    query = "(reviewee_type = :farmer_type and reviewee_id = :farmer_id) or (reviewer_type = :farmer_type and reviewer_id = :farmer_id)"
    Review.where(query, farmer_id: id, farmer_type: "Farmer")
  end

  def reviews_by
    Review.where(reviewer_id: id, reviewer_type: "Farmer")
  end

  def reviews_of
    Review.where(reviewee_id: id, reviewee_type: "Farmer", approved: true)
  end

  def can_view_contact_details(worker)
    job_ids = jobs.pluck(:id)
    worker.job_workers.exists? job_id: job_ids,
                               state: ["interested", "hired", "shortlisted", "not_interested", "declined"]
  end

  def welcome_to_new_site
    if last_sign_in_at.nil?
      raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)

      self.reset_password_token   = enc
      self.reset_password_sent_at = Time.now.utc
      self.save(validate: false)

      EmailService.new.send_email(
        Rails.application.config.smart_email_ids[:farmer_new_site_registration], 
        email,
        {
            full_name: full_name, 
            reset_password_url: edit_password_url(self, reset_password_token: raw)
        }
      )
    end
  end

  def main_app
    Rails.application.class.routes.url_helpers
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
