SidekiqUniqueJobs.configure do |config|
  config.enabled = Rails.env.production?
end
