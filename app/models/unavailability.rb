class Unavailability < ActiveRecord::Base
  belongs_to :worker
  scope :in_range, -> (start_date, end_date) { where("start_date <= ? AND end_date >= ?", start_date, start_date) }

  validates_presence_of :worker
  validates :start_date, presence: true, date: { after_or_equal_to: Proc.new { Date.yesterday }, message: "must be at least #{(Date.yesterday + 1).to_s}" }, on: [:update, :create]
  validates :end_date, presence: true, date: { after: :start_date}, on: [:update, :create]
end
