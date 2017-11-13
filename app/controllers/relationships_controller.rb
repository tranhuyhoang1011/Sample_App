class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      response_action
    else
      find_error
    end
  end

  def destroy
    user = Relationship.find_by id: params[:id]
    if user
      @user = user.followed
      current_user.unfollow @user
      response_action
    else
      find_error
    end
  end

  private

  def response_action
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def find_error
    flash[:danger] = t "follow.user_error"
    redirect_to root_url
  end
end
