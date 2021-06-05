class RoadmapCommentsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_admin_user,   only: :destroy

    def create
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @roadmap_comment = current_user.roadmap_comments.build(roadmap_comment_params)
        if @roadmap_comment.save!
          flash[:success] = "コメントしました！"
          redirect_to user_roadmap_path(@user, @roadmap)
        else
          flash[:danger] = "コメントに失敗しました。文字数などをご確認ください。"
          redirect_to user_roadmap_path(@user, @roadmap)
        end
      end
    
      def destroy
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @roadmap_comment = RoadmapComment.find(params[:id])
      if @roadmap_comment.destroy
        flash[:success] = "コメントが削除されました。"
        redirect_to user_roadmap_path(@user, @roadmap)
      else
        flash[:error] = "コメントが削除されませんでした。"
        redirect_to user_roadmap_path(@user, @roadmap)
      end
    end

      private
      def roadmap_comment_params
        params.require(:roadmap_comment).permit(:comment_content, :roadmap_id)
      end

      def correct_user
        @roadmap_comment = current_user.roadmap_comments.find_by(id: params[:id])
        redirect_to root_url if @roadmap_comment.nil?
      end

        # 管理者かどうか確認
        def admin_user
          redirect_to(root_url) unless current_user.admin?
        end

        def correct_admin_user
          if @roadmap_comment = current_user.roadmap_comments.find_by(id: params[:id]) || current_user.admin
            true
          else
            false
            redirect_to(root_url)
          end
        end
     
end
