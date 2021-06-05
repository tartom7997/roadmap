class RoadmapsController < ApplicationController
    skip_forgery_protection
    before_action :logged_in_user, only: [:new, :create]
    before_action :correct_admin_user,   only: [:edit, :update, :destroy]

    def index
      @roadmaps = Roadmap.paginate(page: params[:page], per_page: 5)
    end

    def all
      @user = User.find(params[:user_id])
      @roadmaps = @user.roadmaps.paginate(page: params[:page], per_page: 5).order("updated_at DESC")
    end

    def show
      @user = User.find(params[:user_id])
      @roadmap = Roadmap.find(params[:id])
      @roadmap_comments = @roadmap.roadmap_comments.paginate(page: params[:page], per_page: 10).order("created_at ASC")
      @roadmap_comment = current_user.roadmap_comments.build if logged_in?
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
        flash[:success] = "ロードマップが更新されました。"
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
        render 'show'
      end
    end

    def hashtag
      if params[:name].nil?
        @hashtags = Hashtag.to_a.group_by{ |hashtag| hashtag.roadmaps.count}
      else
        @hashtag = Hashtag.find_by(hashname: params[:name])
        @roadmap = @hashtag.roadmaps.paginate(page: params[:page], per_page: 5).reverse_order
        @hashtags_paginate = Hashtag.paginate(page: params[:page], per_page: 50)
        @hashtags = @hashtags_paginate.to_a.group_by{ |hashtag| hashtag.roadmaps.count}
      end
    end

    private
  
      def roadmap_params
        if params[:user]
        params.require(:user).permit(:title, :purpose, :target, :picture, :hashbody, hashtag_ids: []).merge(user_id: current_user.id)
        else params[:roadmap]
        params.require(:roadmap).permit(:title, :purpose, :target, :picture, :hashbody, hashtag_ids: []).merge(user_id: current_user.id)
        end
      end

      # 210601_correct_admin_userに変更
      def correct_user
        @roadmap = current_user.roadmaps.find_by(id: params[:id])
        redirect_to root_url if @roadmap.nil?
      end

      def correct_admin_user
        if @roadmap = current_user.roadmaps.find_by(id: params[:id]) || current_user.admin
          true
        else
          false
          redirect_to(root_url)
        end
      end

end
