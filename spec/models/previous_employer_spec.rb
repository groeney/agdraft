require "rails_helper"

RSpec.describe PreviousEmployer, type: :model do
  it { is_expected.to validate_presence_of :worker }
  it { is_expected.to validate_presence_of :job_title }
  it { is_expected.to validate_presence_of :business_name }
  it { is_expected.to validate_presence_of :start_date }
  it { is_expected.to validate_presence_of :end_date }
end
