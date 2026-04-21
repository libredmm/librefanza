# Cloudflare caches 404s for paths with static-looking extensions, so
# /mini-profiler-resources/includes.css gets poisoned for unauthenticated
# visitors and the cached 404 then blocks authenticated admins. Force
# no-store on every response under that prefix so no CDN will cache it.
class MiniProfilerNoStore
  PATH_PREFIX = "/mini-profiler-resources/"

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers["cache-control"] = "no-store, private" if env["PATH_INFO"].start_with?(PATH_PREFIX)
    [status, headers, body]
  end
end

Rails.application.config.middleware.insert_before Rack::MiniProfiler, MiniProfilerNoStore
