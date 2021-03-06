class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, except: %i(index new create)

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @microposts = @user.microposts.user_create.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "mail.info"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "update.fl_suc"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user.delete1"
    else
      flash[:danger] = t "user.delete_error"
    end
    redirect_to users_url
  end

  def following
    @title = t "follow.following"
    @users = @user.following.paginate(page: params[:page])
    render :show_follow
  end

  def followers
    @title = t "follow.follower"
    @users = @user.followers.paginate(page: params[:page])
    render :show_follow
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "user.error"
    redirect_to signup_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "session.pl_log"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless @user == current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
