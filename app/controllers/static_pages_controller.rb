class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build if logged_in?
    followed_ids = Relationship.followed_ids(current_user.id)
    @feed_items = Micropost.feed_for(current_user.id, followed_ids).user_create.paginate page: params[:page]
  end

  def help; end

  def about; end

  def contact; end
end
