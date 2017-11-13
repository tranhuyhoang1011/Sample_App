class SessionController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        login_and_remember user
      else
        flash_not_active
      end
    else
      flash_error
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_and_remember user
    log_in user
    params[:session][:remember_me] == Settings.user.session ? remember(user) : forget(user)
    redirect_back_or user
  end

  def flash_not_active
    message = t "mail.acc_not_activated"
    flash[:warning] = message
    redirect_to root_url
  end

  def flash_error
    flash.now[:danger] = t("session.invalid_email_pass")
    render :new
  end
end
