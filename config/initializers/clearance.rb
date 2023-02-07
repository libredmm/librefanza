Clearance.configure do |config|
  config.routes = true # We want to set our own
  config.mailer_sender = "reply@example.com"
  config.rotate_csrf_on_sign_in = true
end
