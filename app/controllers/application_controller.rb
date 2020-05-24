class ApplicationController < ActionController::Base
  include Clearance::Controller

  before_action do
    Rack::MiniProfiler.authorize_request if signed_in_as_admin?
  end

  helper_method :signed_in_as_admin?

  def signed_in_as_admin?
    signed_in? && current_user.is_admin?
  end
end
