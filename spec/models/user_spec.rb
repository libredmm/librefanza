require "rails_helper"

RSpec.describe User, type: :model do
  describe ".reset_api_token!" do
    it "works" do
      user = create :user
      expect {
        user.reset_api_token!
      }.to change {
        user.api_token
      }
    end
  end

  context "on create" do
    it "generates api token" do
      user = create :user
      expect(user.api_token).not_to be_blank
    end
  end

  context "on update" do
    it "validates api token" do
      user = create :user
      user.api_token = ""
      expect {
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
