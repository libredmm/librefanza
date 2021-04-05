SidekiqUniqueJobs.configure do |config|
  config.enabled = Rails.env.production?
  config.lock_prefix = ENV["SIDEKIQ_UNIQUE_PREFIX"] || "uniquejobs"
end

Sidekiq.configure_server do |config|
  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end
