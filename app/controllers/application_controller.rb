class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionHelper

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "session.pl_log"
    redirect_to login_url
  end
end
