class ApplicationController < ActionController::Base
  def godmode?
    cookies[:whosyourdaddy].present?
  end

  def godmode!
    if godmode?
      cookies.delete :whosyourdaddy
    else
      cookies.permanent[:whosyourdaddy] = "whosyourdaddy"
    end
  end

  helper_method :godmode?
end
