class Certificate < ActiveRecord::Base
  belongs_to :worker

  validates_presence_of :worker
  validates_presence_of :title
  validates :issue_date, presence: true, date: { before: Proc.new { Date.tomorrow }, message: "Must be issued before at least #{(Date.tomorrow).to_s}" }, on: [:update, :create]
end
