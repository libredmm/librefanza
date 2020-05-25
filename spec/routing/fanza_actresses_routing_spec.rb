require "rails_helper"

RSpec.describe FanzaActressesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/actresses").to route_to("fanza_actresses#index")
    end
  end
end
