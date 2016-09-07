class Job < ActiveRecord::Base
  belongs_to :farmer
  belongs_to :location
  has_and_belongs_to_many :workers, -> { uniq }
  has_and_belongs_to_many :job_categories, -> { uniq }
  has_and_belongs_to_many :skills, -> { uniq }
  validates_presence_of :title
  validates :end_date, presence: true, date: { after: :start_date, message: "Job end date must be after the start date" }, on: [:update, :create]
  validates :start_date, presence: true, date: { after: Proc.new { Date.today } }, on: [:update, :create]

  accepts_nested_attributes_for :skills
end
