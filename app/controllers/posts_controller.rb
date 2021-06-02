class PostsController < ApplicationController
    before_action :logged_in_user, only: [:new, :create]
    before_action :correct_admin_user,   only: [:edit, :update, :destroy]

    def index
      @all_post = Post.includes({:step => {:roadmap => :user}}, :rich_text_content).order(created_at: :desc).paginate(page: params[:page], per_page: 20)
      @posts = Post.paginate(page: params[:page], per_page: 20)
    end

    def all
      @user = User.find(params[:user_id])
      @roadmap = Roadmap.find(params[:roadmap_id])
      @step = Step.find(params[:step_id])
      @post = @step.posts.build
      @posts = @step.posts.includes(:rich_text_content).paginate(page: params[:page], per_page: 20).order("created_at ASC")
    end

    def show
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = Step.find(params[:step_id])
        @post = Post.find(params[:id])
        @post_sprit_content = ActionController::Base.helpers.strip_tags(@post.content.to_s).gsub(/[\n]/,"").strip.truncate(140)
        @post_comments = @post.post_comments.paginate(page: params[:page], per_page: 20).order("created_at ASC")
        @post_comment = current_user.post_comments.build
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
          mechanize_title(@post)
          mechanize_description(@post)
          mechanize_image(@post)
          flash[:success] = "独学が記録されました！"
          redirect_to all_user_roadmap_step_posts_path(@user, @roadmap, @step)
        else
          flash[:danger] = "独学の記録に失敗しました。すべての項目を入力してください。"
          @posts = @step.posts.paginate(page: params[:page], per_page: 20).order("created_at ASC")
          render 'all'
        end
    end

    def edit
    end

    def update
        @post = Post.find(params[:id])
      if @post.update(post_params)
        mechanize_title(@post)
        mechanize_description(@post)
        mechanize_image(@post)
        # 更新に成功した場合を扱う。
        flash[:success] = "独学の記録が更新されました。"
        redirect_to all_user_roadmap_step_posts_path(@user, @roadmap, @step)
      else
        render 'edit'
      end
    end

    def destroy
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = Step.find(params[:step_id])
        @post = Post.find(params[:id])
      if @post.destroy
        flash[:success] = "独学の記録が削除されました。"
        redirect_to all_user_roadmap_step_posts_url(id: @post, user_id: current_user)
      else
        flash[:error] = "独学の記録が削除されませんでした。"
        @posts = @step.posts.paginate(page: params[:page], per_page: 20).order("created_at ASC")
        render 'all'
      end
    end

    def hashtag
      if params[:name].nil?
        @hashtags = Hashtag.includes(:posts).to_a.group_by{ |hashtag| hashtag.posts.count}
      else
        @hashtag = Hashtag.includes(:posts).find_by(hashname: params[:name])
        @post = @hashtag.posts.includes({:step => {:roadmap => :user}}, :rich_text_content).paginate(page: params[:page], per_page: 20).reverse_order
        @hashtags_paginate = Hashtag.includes(:posts).paginate(page: params[:page], per_page: 50)
        @hashtags = @hashtags_paginate.to_a.group_by{ |hashtag| hashtag.posts.count}
      end
    end

    private
  
      def post_params
        params.require(:post).permit(:title, :content, :url, :category_id, :picture, :hashbody, hashtag_ids: [])
      end

      # 210601_correct_admin_userに変更
      def correct_user
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = Step.find(params[:step_id])
        @post = @step.posts.find_by(id: params[:id])
        redirect_to root_url if @post.nil?
      end


      def mechanize_title(post)
        if post.url.present?
          agent = Mechanize.new
          page = agent.get(post.url)
          if page.title.present?
            title = page.title
            post.update(url_title: title)
          else
            "no title"
          end
        end
      end

      def mechanize_description(post)
        if post.url.present?
          agent = Mechanize.new
          page = agent.get(post.url)
          if page.at("meta[property='og:description']").present?
            description = page.at("meta[property='og:description']")[:content]
            post.update(url_description: description)
          else
            "no description"
          end
        end
      end

      def mechanize_image(post)
        if post.url.present?
          agent = Mechanize.new
          page = agent.get(post.url)
          if page.at("meta[property='og:image']").present?
            image = page.at("meta[property='og:image']")[:content]
            post.update(url_image: image)
          else
            "no image"
          end
        end
      end

      # def content_copy(post)
      #   strip_content = ActionController::Base.helpers.strip_tags(@post.content.to_s).gsub(/[\n]/,"").strip
      #   post.update(content: strip_content)
      # end

      def correct_admin_user
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = Step.find(params[:step_id])
        @post = @step.posts.find_by(id: params[:id])
        if current_user == @user || current_user.admin
          true
        else
          false
          redirect_to(root_url)
        end
      end

end
