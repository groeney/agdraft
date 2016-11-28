class Review < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :reviewee, polymorphic: true
  belongs_to :reviewer, polymorphic: true
  belongs_to :job

  validates_presence_of :reviewee
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

  def title_text
    if job
      job.title
    elsif reviewer
      reviewer.full_name
    elsif title && !title.empty?
      title
    else
      "Anonymous"
    end
  end

  # this method is used to determine the correct rating to display
  # there are these two ways of calculating because the review system
  # ended up being modified to facilitate different types of reviews
  # for farmers and workers - this was decided after this system had been built
  # Ideally, since this has changed so much, we would now preffer to have a different review model for Farmer and Worker..
  def overall_rating
    # When it is a review of a Worker
    if communication && skills && work_ethic && recommended
      return ((communication + skills + work_ethic + recommended)/4.0).round
    # When it is a reivew of a Farmer
    else
      return rating
    end
  end

  protected

  def reviewee_exists    
    unless reviewee
      errors.add(:reviewee_id, "Reviewee must exist")
    end
  end
end
