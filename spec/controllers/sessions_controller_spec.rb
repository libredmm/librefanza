require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "#url_after_create" do
    it "returns session[:return_to] when set" do
      controller.session[:return_to] = "/fanza_items"

      expect(controller.send(:url_after_create)).to eq("/fanza_items")
      expect(controller.session[:return_to]).to be_nil
    end

    it "returns root_path when return_to is not set" do
      expect(controller.send(:url_after_create)).to eq(root_path)
    end
  end

  describe "#store_return_to" do
    it "stores return_to param in session" do
      allow(controller).to receive(:params).and_return({ return_to: "/movies" })

      controller.send(:store_return_to)

      expect(controller.session[:return_to]).to eq("/movies")
    end

    it "does not store when return_to is already in session" do
      controller.session[:return_to] = "/existing"
      allow(controller).to receive(:params).and_return({ return_to: "/movies" })

      controller.send(:store_return_to)

      expect(controller.session[:return_to]).to eq("/existing")
    end

    it "does not store when return_to param is blank" do
      allow(controller).to receive(:params).and_return({})

      controller.send(:store_return_to)

      expect(controller.session[:return_to]).to be_nil
    end

    it "does not store non-local paths to prevent open redirect" do
      allow(controller).to receive(:params).and_return({ return_to: "http://evil.com" })

      controller.send(:store_return_to)

      expect(controller.session[:return_to]).to be_nil
    end
  end
end
