require "rails_helper"

RSpec.describe JavlibrarySearchJob, type: :job do
  include ActiveJob::TestHelper

  before(:each) do
    if JavlibrarySearchJob.class_variable_defined? :@@client
      JavlibrarySearchJob.remove_class_variable :@@client
    end

    @client = spy("client")
    allow(Javlibrary::Client).to receive(:new).and_return(@client)

    @pages = 5.times.map {
      [generate(:url), "<html></html>"]
    }.to_h
    allow(@client).to receive(:search).and_return(@pages)

    allow(JavlibraryPage).to receive(:create)
  end

  it "searches javlibrary" do
    id = generate :normalized_id
    perform_enqueued_jobs do
      JavlibrarySearchJob.perform_later id
    end

    expect(@client).to have_received(:search).with(id)
  end

  it "creates javlibrary pages" do
    id = generate :normalized_id
    perform_enqueued_jobs do
      JavlibrarySearchJob.perform_later id
    end

    @pages.each do |url, html|
      expect(JavlibraryPage).to have_received(:create).with(url: url, raw_html: html)
    end
  end
end
