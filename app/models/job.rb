class Job < ActiveRecord::Base
  belongs_to :farmer
  belongs_to :location
  has_and_belongs_to_many :workers, -> { uniq }
  has_and_belongs_to_many :job_categories, -> { uniq }
  has_and_belongs_to_many :skills, -> { uniq }
  has_many :payment_audits
  validates_presence_of :title
  validates :end_date, presence: true, date: { after: :start_date, message: "Job end date must be after the start date" }, on: [:update, :create]
  validates :start_date, presence: true, date: { after: Proc.new { Date.today } }, on: [:update, :create]

  accepts_nested_attributes_for :skills

  def start_date_label
    start_date.strftime("%B %e %Y") if start_date
  end

  def end_date_label
    end_date.strftime("%B %e %Y") if end_date
  end

  def publish
    return true if published
    unless farmer.has_valid_payment?
      return false
    end
    unless StripeService.charge_job(id, JOB_PRICE)
      return false
    end
    update_attribute(:published, true)
  end
end
