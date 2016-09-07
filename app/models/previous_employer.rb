class PreviousEmployer < ActiveRecord::Base
  belongs_to :worker

  validates_presence_of :worker
  validates_presence_of :business_name
  validates_presence_of :job_title
  validates :end_date, presence: true, date: { before: Proc.new { Date.tomorrow }, message: "Must end previous employment before at least #{(Date.tomorrow).to_s}" }, on: [:update, :create]
  validates :start_date, presence: true, date: { before: :end_date }, on: [:update, :create]
end
