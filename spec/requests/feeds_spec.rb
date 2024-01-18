require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/feeds", type: :request do
  let(:feed) { create(:feed) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  
  describe "GET /feeds" do
    it "works for admin" do
      get feeds_path(as: admin)
      expect(response).to be_successful
    end

    it "rejects other users" do
      expect {
        get feeds_path(as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /feeds/:id" do
    it "works for admin" do
      get feed_path(feed, as: admin)
      expect(response).to be_successful
    end

    it "rejects other users" do
      expect {
        get feed_path(feed, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "DELETE /feeds/:id" do
    it "works for admin" do
      delete feed_path(feed, as: admin)
      expect(response).to be_redirect
    end

    it "rejects other users" do
      expect {
        delete feed_path(feed, as: user)
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "PUT /feeds/:id" do
    it "works for admin" do
      put feed_path(feed, as: admin, params: { feed: { tag: "new tag" } })
      expect(response).to be_redirect
    end

    it "rejects other users" do
      expect {
        put feed_path(feed, as: user, params: { feed: { tag: "new tag" } })
      }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "GET /pipe" do
    before(:each) do
      @rss_stub = stub_request(:any, %r{rss.example.com}).to_return(
        body: %q{
  <?xml version="1.0" encoding="utf-8" ?>
  <rss version="2.0">
  <channel>
  <item>
  <title><![CDATA[ABC-123 甲乙丙丁]]></title>
  </item>
  <item>
  <title><![CDATA[戊己 DEF-456 庚辛]]></title>
  </item>
  <item>
  <title><![CDATA[壬癸 GHI-789]]></title>
  </item>
  <item>
  <title><![CDATA[abc-456]]></title>
  </item>
  <item>
  <title><![CDATA[JKL-001]]></title>
  </item>
  <item>
  <title><![CDATA[123JKL-456]]></title>
  </item>
  <item>
  <title><![CDATA[MINUS-123]]></title>
  <guid>abcdef</guid>
  </item>
  </channel>
  </rss>
  XML
  },
      )
      @plex_stub = stub_request(:any, %r{exclude.example.com}).to_return(
        body: "ABC-123\nABC-456",
      )
      @blacklist_stub = stub_request(:any, %r{blacklist.example.com}).to_return(
        body: "GHI\nJKL",
      )
      @whitelist_stub = stub_request(:any, %r{whitelist.example.com}).to_return(
        body: "GHI",
      )
      @minus_stub = stub_request(:any, %r{minus.example.com}).to_return(
        body: %q{
  <?xml version="1.0" encoding="utf-8" ?>
  <rss version="2.0">
  <channel>
  <item>
  <title><![CDATA[MINUS-123]]></title>
  <guid>abcdef</guid>
  </item>
  <item>
  <title><![CDATA[NOGUID-456]]></title>
  </item>
  </channel>
  </rss>
  XML
  },
      )
    end

    it "works" do
      get feeds_pipe_path(
        src: "https://rss.example.com",
        exclude: "https://exclude.example.com",
        blacklist: "https://blacklist.example.com",
        minus: "https://minus.example.com",
      )
      expect(response).to have_http_status(200)
      expect(response.body).not_to include("ABC-123")
      expect(response.body).to include("DEF-456")
      expect(response.body).not_to include("GHI-789")
      expect(response.body).not_to include("abc-456")
      expect(response.body).not_to include("123JKL-456")
      expect(response.body).not_to include("MINUS-123")
    end

    it "works without blacklist" do
      get feeds_pipe_path(
        src: "https://rss.example.com",
        exclude: "https://exclude.example.com",
      )
      expect(response).to have_http_status(200)
      expect(response.body).not_to include("ABC-123")
      expect(response.body).to include("DEF-456")
      expect(response.body).to include("GHI-789")
      expect(response.body).not_to include("abc-456")
    end

    it "prioritizes whitelist over blacklist" do
      get feeds_pipe_path(
        src: "https://rss.example.com",
        exclude: "https://exclude.example.com",
        blacklist: "https://blacklist.example.com",
        whitelist: "https://whitelist.example.com",
      )
      expect(response).to have_http_status(200)
      expect(response.body).to include("GHI-789")
      expect(response.body).not_to include("JKL-001")
    end
  end
end