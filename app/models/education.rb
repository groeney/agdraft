class Education < ActiveRecord::Base
  belongs_to :worker

  validates_presence_of :worker
  validates_presence_of :school
  validates :end_date, presence: true, date: { before: Proc.new { Date.tomorrow }, message: "Must end education before at least #{(Date.tomorrow).to_s}" }, on: [:update, :create]
  validates :start_date, presence: true, date: { before: :end_date }, on: [:update, :create]

  def start_date_label
    return "" unless start_date
    start_date.strftime("%B %e %Y")
  end

  def end_date_label
    return "" unless end_date
    end_date.strftime("%B %e %Y")
  end
end
