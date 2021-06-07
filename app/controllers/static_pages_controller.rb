class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      # micropostのフィード
      # @feed_items = current_user.feed.paginate(page: params[:page])
      @user = current_user
      @roadmap_first  = current_user.roadmaps.order(updated_at: :desc).first
      @post = current_user.feed_post.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
      # @feed_post_items = current_user.feed_post.paginate(page: params[:page]).order(created_at: :desc)
    end
  end
  
  def help
  end

  def about
  end

  def contact
  end

  def error
  end

end
