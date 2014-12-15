class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def load_portal
    @portal = Portal.find_by_url!(request.subdomain) rescue nil
  end
end
