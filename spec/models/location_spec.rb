require "rails_helper"

RSpec.describe Skill, type: :model do
  describe "#label" do
    let(:location){ FactoryGirl.create(:location) }
    it "formats the state and region correctly" do
      expect(location.label).to eq "#{location.region}, #{location.state}"
    end
  end
end