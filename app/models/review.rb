class Review < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :reviewee, polymorphic: true
  belongs_to :reviewer, polymorphic: true
  belongs_to :job

  validates_presence_of :reviewee
  validates :rating, inclusion: { in: [*1..5] }
  validate :reviewer_can_review_reviewee, on: :create
  validate :reviewee_exists

  def reviewee_profile_path
    return "#" if reviewee_id == nil
    return worker_path(reviewee_id) if reviewee_type == "Worker"
    farmer_path(reviewee_id)
  end

  def reviewer_profile_path
    return "#" if reviewer_id == nil
    return worker_path(reviewer_id) if reviewer_type == "Worker"
    farmer_path(reviewer_id)
  end

  def reviewer_can_review_reviewee
    if reviewer
      unless reviewer.try(:can_review, reviewee_id)
        errors.add(:reviewee_id, "Reviewer does not have permission to review reviewee.")
      end
    end
  end

  protected

  def reviewee_exists
    unless reviewee
      errors.add(:reviewee_id, "Reviewee must exist")
    end
  end
end
