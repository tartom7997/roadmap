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
    else
      @roadmaps = Roadmap.includes(:like_roadmaps, :steps => :posts).where(
        like_roadmaps: { 
          created_at: Time.now.all_month
        }).limit(3).sort {|a,b| b.liking_users.size <=> a.liking_users.size}
    end
  end

  def about
  end

  def contact
  end

  def error
  end
    
  def mail_send
  end

end
