class Job < ActiveRecord::Base
  include Recommendable, Filterable
  is_impressionable

  belongs_to              :farmer
  belongs_to              :location
  has_many                :job_workers
  has_many                :payment_audits
  has_many                :recommendations, as: :resource, dependent: :destroy
  has_many                :reviews
  has_and_belongs_to_many :job_categories, -> { uniq }
  has_and_belongs_to_many :skills, -> { uniq }
  validates_presence_of   :title

  validates :end_date, presence: true, date: { after: :start_date, message: "Job end date must be after the start date" }, on: [:update, :create]
  validates :start_date, presence: true, date: { after: Proc.new { |j| Date.today } }, on: [:update, :create], if: "!published"

  scope :locations, -> (location_ids) { where(location_id: location_ids) }
  scope :job_categories, -> (job_category_ids) { joins(:job_categories).where(job_categories: { id: job_category_ids }) }
  scope :skills, -> (skill_ids) { joins(:skills).where(skills: { id: skill_ids }) }
  scope :date_range, -> (start_date, end_date) { where("start_date >= ? AND end_date <= ?", start_date, end_date) }
  scope :visibles, -> () { where(published: true) }
  after_create :analytics
  after_update :track_publish_event

  accepts_nested_attributes_for :skills

  def analytics
    Analytics.track(
      user_id: self.farmer.analytics_id,
      event: "Farmer Created Job",
      properties: { job_id: self.id, job_title: self.title })
  end

  def track_publish_event
    if self.published_changed?
      Analytics.track(
        user_id: self.farmer.analytics_id,
        event: "Farmer Published Job",
        properties: { job_id: self.id, job_title: self.title })
    end
  end

  def start_date_label
    return "" unless start_date
    start_date.strftime("%B %e %Y")
  end

  def end_date_label
    return "" unless end_date
    end_date.strftime("%B %e %Y")
  end

  def publish
    return true if published
    # Ultimately this would be better in a CreditService object that could handle all the complexity of a credit system
    # this is just a very basic implimentation to get this V1 out the door
    value_to_charge = JOB_PRICE
    if farmer.credit > 0
      credit = credit_to_apply
      value_to_charge = JOB_PRICE - credit
      farmer.update_attribute(:credit, farmer.credit - credit)
      PaymentAudit.create(farmer: farmer, job_id: id, action: "Credit Applied", amount: credit, success: true)
    end
    if value_to_charge > 0
      unless farmer.has_valid_payment? && StripeService.charge_job(id, value_to_charge * 100) #stripe charges in cents hence multiply by 100
        return false
      end
    end

    update_attributes(published: true, published_at: Time.now)
    true
  end

  def location_name
    return "" unless location
    [location.region, location.state].reject { |el| el.empty? }.join(", ")
   end

  def filter_rating(filter_params)
    raw_rating = 0
    filter_params.slice(:skills, :job_categories).each do |key, ids|
      raw_rating += self.public_send(key).where({ id: ids }).count if ids.present?
    end
    if filter_params[:locations] && filter_params[:locations].include?(self.location.id)
      raw_rating += 1
    end
    raw_rating
  end

  def review_rating
    farmer.review_rating
  end

  def credit_to_apply
    (JOB_PRICE - farmer.credit) < 1 ? JOB_PRICE : farmer.credit
  end

  def recommended_workers
    invalid_worker_ids = JobWorker.where({ job_id: id }).pluck(:worker_id)
    Worker.recommend({ skills: skill_ids, job_categories: job_category_ids, locations: [location.id] },
                     invalid_worker_ids)
  end

  def skill_ids
    skills.pluck(:id)
  end

  def job_category_ids
    job_categories.pluck(:id)
  end

  def hired_job_workers
    job_workers.where({ state: "hired" })
  end

  def archive
    update_attributes(archived: true, archived_at: Time.now, live: false)
    update_attribute(:published, false)
    return false unless errors.empty?
    true
  end
end
