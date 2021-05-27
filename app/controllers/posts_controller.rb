class PostsController < ApplicationController
    before_action :logged_in_user, only: [:new, :create]
    before_action :correct_user,   only: [:edit, :update, :destroy]
  
    def index
      @all_post = Post.joins({:step => {:roadmap => :user}}).all.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
      @posts = Post.paginate(page: params[:page], per_page: 5)
    end

    def all
      @user = User.find(params[:user_id])
      @roadmap = Roadmap.find(params[:roadmap_id])
      @step = Step.find(params[:step_id])
      @post = @step.posts.build
      @posts = @step.posts.paginate(page: params[:page], per_page: 5).order("created_at ASC")
    end

    def show
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = Step.find(params[:step_id])
        @post = Post.find(params[:id])
    end

    def new
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = Step.find(params[:step_id])
        @post = Post.find(params[:id])
    end

    def create
      @user = User.find(params[:user_id])
      @roadmap  = Roadmap.find(params[:roadmap_id])
      @step = Step.find(params[:step_id])
      @post = @step.posts.build(post_params)
        if @post.save
            flash[:success] = "独学が記録されました！"
            redirect_to all_user_roadmap_step_posts_path(@user, @roadmap, @step)
        else
            flash[:danger] = "独学の記録に失敗しました。すべての項目を入力してください。"
            @posts = @step.posts.paginate(page: params[:page], per_page: 5).order("created_at ASC")
            render 'all'
        end
    end

    def edit
    end

    def update
        @post = Post.find(params[:id])
      if @post.update(post_params)
        # 更新に成功した場合を扱う。
        flash[:success] = "独学の記録が更新されました。"
        redirect_to all_user_roadmap_step_posts_path(@user, @roadmap, @step)
      else
        render 'edit'
      end
    end

    def destroy
        @post = Post.find(params[:id])
      if @post.destroy
        flash[:success] = "独学の記録が削除されました。"
        redirect_to all_user_roadmap_step_posts_url(id: @post, user_id: current_user)
      else
        flash[:error] = "独学の記録が削除されませんでした。"
        @posts = @step.posts.paginate(page: params[:page], per_page: 5).order("created_at ASC")
        render 'all'
      end
    end

    def hashtag
      if params[:name].nil?
        @hashtags = Hashtag.all.to_a.group_by{ |hashtag| hashtag.posts.count}
      else
        @hashtag = Hashtag.find_by(hashname: params[:name])
        @post = @hashtag.posts.paginate(page: params[:page], per_page: 5).reverse_order
        @hashtags_paginate = Hashtag.all.paginate(page: params[:page], per_page: 50)
        @hashtags = @hashtags_paginate.all.to_a.group_by{ |hashtag| hashtag.posts.count}
      end
    end


    private
  
      def post_params
        params.require(:post).permit(:title, :content, :url, :category_id, :hashbody, hashtag_ids: [])
      end

      def correct_user
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = Step.find(params[:step_id])
        @post = @step.posts.find_by(id: params[:id])
        redirect_to root_url if @post.nil?
      end

end
