class PostCommentsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_admin_user,   only: :destroy

    def create
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = Step.find(params[:step_id])
        @post = Post.find(params[:post_id])
        @post_comment = current_user.post_comments.build(post_comment_params)
        if @post_comment.save!
          flash[:success] = "コメントしました！"
          redirect_to user_roadmap_step_post_path(@user, @roadmap, @step, @post)
        else
          flash[:danger] = "コメントに失敗しました。文字数などをご確認ください。"
          redirect_to user_roadmap_step_post_path(@user, @roadmap, @step, @post)
        end
      end
    
      def destroy
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = Step.find(params[:step_id])
        @post = Post.find(params[:post_id])
        @post_comment = PostComment.find(params[:id])
      if @post_comment.destroy
        flash[:success] = "コメントが削除されました。"
        redirect_to user_roadmap_step_post_path(@user, @roadmap, @step, @post)
      else
        flash[:error] = "コメントが削除されませんでした。"
        redirect_to user_roadmap_step_post_path(@user, @roadmap, @step, @post)
      end
    end

      private
      def post_comment_params
        params.require(:post_comment).permit(:comment_content, :post_id)
      end

      def correct_user
        @post_comment = current_user.post_comments.find_by(id: params[:id])
        redirect_to root_url if @post_comment.nil?
      end

        # 管理者かどうか確認
        def admin_user
          redirect_to(root_url) unless current_user.admin?
        end

        def correct_admin_user
          if @post_comment = current_user.post_comments.find_by(id: params[:id]) || current_user.admin
            true
          else
            false
            redirect_to(root_url)
          end
        end
     

end
