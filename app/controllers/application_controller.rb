class ApplicationController < ActionController::Base
  def godmode?
    cookies[:whosyourdaddy].present?
  end

  def godmode!
    cookies.permanent[:whosyourdaddy] = "whosyourdaddy"
  end

  def mortal!
    cookies.delete :whosyourdaddy
  end

  helper_method :godmode?
end
