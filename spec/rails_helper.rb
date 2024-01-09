require "simplecov"
SimpleCov.start "rails" do
  add_filter %r{^/app/mailers/}
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before(:each) do
    @item_list_stub = stub_request(:any, %r{/affiliate/v3/ItemList}).to_return(
      body: ->(request) {
        {
          result: {
            result_count: request.uri.query_values["hits"].to_i,
            total_count: request.uri.query_values["hits"].to_i * 2,
            first_position: request.uri.query_values["offset"].to_i,
            items: [{
              service_code: request.uri.query_values["service"],
              floor_code: request.uri.query_values["floor"],
              content_id: request.uri.query_values["keyword"] || generate(:normalized_id),
              title: "Title",
              URL: generate(:url),
              imageURL: {
                large: generate(:url),
                small: generate(:url),
              },
              date: DateTime.now.to_s,
            }],
          },
        }.to_json
      },
    )

    @actress_search_stub = stub_request(:any, %r{/affiliate/v3/ActressSearch}).to_return(
      body: ->(request) {
        hits = 4
        total = 20
        offset = request.uri.query_values["offset"].to_i
        {
          result: {
            result_count: hits,
            total_count: total,
            first_position: offset,
            actress: hits.times.map { |i|
              {
                id: offset + i,
                name: generate(:name),
                imageURL: {
                  large: generate(:url),
                  small: generate(:url),
                },
              }
            },
          },
        }.to_json
      },
    )

    @sod_stub = stub_request(:any, %r{ec.sod.co.jp}).to_return(
      body: "<html></html>",
    )

    @mgstage_stub = stub_request(:any, %r{mgstage.com}).to_return(
      body: "<html></html>",
    )
    @mgstage_search_stub = stub_request(:any, %r{mgstage.com/search}).to_return(
      body: "<html><div class='search_list'><h5><a href='https://www.mgstage.com/product/product_detail/ABC-123/'>ABC-123</a></h5></div></html>",
    )

    @javlibrary_stub = stub_request(:any, %r{javlibrary.com}).to_return(
      body: "<html></html>",
    )

    @rss_stub = stub_request(:any, %r{rss.example.com}).to_return(
      body: %q{
<?xml version="1.0" encoding="utf-8" ?>
<rss version="2.0">
<channel>
<title>RSS Title</title>
<link>https://example.com</link>
<item>
<title>Item 1</title>
<link>https://example.com/items/1</link>
</item>
<item>
<title>Item 2</title>
<link>https://example.com/items/2</link>
</item>
</channel>
</rss>
},
    )

    stub_request(:any, %r{http://example.com/}).to_return(
      body: "<html></html>",
    )
  end
end
