SidekiqUniqueJobs.configure do |config|
  config.enabled = Rails.env.production?
  config.unique_prefix = ENV["SIDEKIQ_UNIQUE_PREFIX"] || "uniquejobs"
end
