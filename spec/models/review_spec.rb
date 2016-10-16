require "rails_helper"

RSpec.describe Review, type: :model do
  it { is_expected.to validate_presence_of :reviewee }
  it { is_expected.to validate_inclusion_of(:rating).in_array([*1..5]) }

  it { is_expected.to belong_to :reviewee }
  it { is_expected.to belong_to :reviewer }
end
