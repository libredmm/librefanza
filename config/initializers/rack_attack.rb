ENV.fetch("SAFELIST_IP", "").split.each do |ip|
  Rack::Attack.safelist_ip ip
end

ENV.fetch("BLOCKLIST_IP", "").split.each do |ip|
  Rack::Attack.blocklist_ip ip
end

Rack::Attack.throttle("requests by ip", limit: 5, period: 2) do |request|
  request.ip
end
