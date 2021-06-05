class LikePostsController < ApplicationController
    before_action :set_variables

    def like
      like = current_user.like_posts.new(post_id: @post.id)
      like.save
      redirect_back(fallback_location: root_path)
    end
  
    def unlike
      like = current_user.like_posts.find_by(post_id: @post.id)
      like.destroy
      redirect_back(fallback_location: root_path)
    end
  
    private
    def set_variables
      @post = Post.find(params[:post_id])
    end

end
