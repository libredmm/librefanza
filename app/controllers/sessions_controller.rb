class SessionsController < Clearance::SessionsController
  def new
    store_return_to
    super
  end

  private

  def store_return_to
    return if session[:return_to].present?
    return if params[:return_to].blank?

    # Only allow local paths to prevent open redirect
    return unless params[:return_to].start_with?("/")

    session[:return_to] = params[:return_to]
  end

  def url_after_create
    session.delete(:return_to) || super
  end
end
