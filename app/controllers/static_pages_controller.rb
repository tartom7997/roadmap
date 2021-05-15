class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @user = current_user
      @roadmap  = current_user.roadmaps.order(updated_at: :desc).first
      @step  = @roadmap.steps.build
    end
  end
  
  def help
  end

  def about
  end

  def contact
  end

end
