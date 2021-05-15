class RoadmapsController < ApplicationController
    skip_forgery_protection
    before_action :logged_in_user, only: [:new, :create]
    before_action :correct_user,   only: [:edit, :update, :destroy]

    def index
      @roadmaps = Roadmap.paginate(page: params[:page], per_page: 5)
    end

    def all
      @user = User.find(params[:user_id])
      @roadmaps = @user.roadmaps.paginate(page: params[:page], per_page: 5).order("updated_at DESC")
    end

    def show
      @user = User.find(params[:user_id])
      @roadmaps = @user.roadmaps.paginate(page: params[:page], per_page: 5).order("updated_at DESC")
      @roadmap = Roadmap.find(params[:id])
    end

    def new
      @roadmap = current_user
    end

    def create
      @roadmap = current_user.roadmaps.build(roadmap_params)
      if @roadmap.save
        flash[:success] = "新しいロードマップが作成されました！"
        redirect_to all_user_roadmaps_url(user_id: current_user)
      else
        flash[:danger] = "新しいロードマップの作成に失敗しました。"
        render 'new'
      end
    end
  
    def edit
    end

    def update
      @roadmap = Roadmap.find(params[:id])
      if @roadmap.update(roadmap_params)
        # 更新に成功した場合を扱う。
        flash[:success] = "プロフィールが更新されました。"
        redirect_to all_user_roadmaps_url(user_id: current_user)
      else
        render 'edit'
      end
    end
    
    def learnig
      @roadmap = Roadmap.find(params[:id])
      @roadmap.update_attribute(:updated_at, Time.now)
      flash[:success] = "ロードマップが設定されました。"
      redirect_to root_url
    end
    
    def destroy
      @roadmap = Roadmap.find(params[:id])
      if @roadmap.destroy
        flash[:success] = "ロードマップが削除されました。"
        redirect_to all_user_roadmaps_url(user_id: current_user)
      else
        flash[:error] = "ロードマップが削除されませんでした。"
      rrender 'show'
      end
    end

    private
  
      def roadmap_params
        if params[:user]
        params.require(:user).permit(:title, :purpose, :target, :picture).merge(user_id: current_user.id)
        else params[:roadmap]
        params.require(:roadmap).permit(:title, :purpose, :target, :picture).merge(user_id: current_user.id)
        end
      end

      def correct_user
        @roadmap = current_user.roadmaps.find_by(id: params[:id])
        redirect_to root_url if @roadmap.nil?
      end
end
