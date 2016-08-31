class Workers::OnboardController < ApplicationController
  def job_categories
    @job_categories = JobCategory.all
  end

  def skills
  end
end
