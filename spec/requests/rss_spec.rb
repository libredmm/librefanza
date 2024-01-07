require "rails_helper"

RSpec.describe "Rss", type: :request do
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

  describe "GET /pipe" do
    it "works" do
      get rss_pipe_path(
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
      get rss_pipe_path(
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
      get rss_pipe_path(
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
