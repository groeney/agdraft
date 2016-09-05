require "rails_helper"

RSpec.describe Unavailability, type: :model do
  it { is_expected.to validate_presence_of :worker }
  it { is_expected.to validate_presence_of :start_date }
  it { is_expected.to validate_presence_of :end_date }

  it { is_expected.to belong_to :worker }
end
