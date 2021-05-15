class StepsController < ApplicationController
    before_action :logged_in_user, only: [:new, :create]
    before_action :correct_user,   only: [:edit, :update, :destroy]
  
    def index
      @user = User.find(params[:user_id])
      @roadmap = Roadmap.find(params[:roadmap_id])
      @steps = @roadmap.steps.paginate(page: params[:page], per_page: 5).order("updated_at DESC")
      @step = @roadmap.steps.build
    end

    def show
      @user = User.find(params[:user_id])
      @roadmap = Roadmap.find(params[:roadmap_id])
      @step = Step.find(params[:id])
    end

    def new
      # @user = User.find(params[:user_id])
      # @roadmap  = Roadmap.find(params[:roadmap_id])
    end

    def create
      @user = User.find(params[:user_id])
      @roadmap  = Roadmap.find(params[:roadmap_id])
      @step = @roadmap.steps.build(step_params)
        if @step.save
            flash[:success] = "投稿が作成されました！"
            redirect_to user_roadmap_steps_path(@user, @roadmap)
        else
            @feed_items = []
            # render 'static_pages/home'
            flash[:danger] = "投稿に失敗しました。"
            redirect_to user_roadmap_steps_path(@user, @roadmap)
        end
    end

    def edit
    end

    def update
      @step = Step.find(params[:id])
      if @step.update(step_params)
        # 更新に成功した場合を扱う。
        flash[:success] = "プロフィールが更新されました。"
        redirect_to user_roadmap_steps_path(@user, @roadmap)
      else
        render 'edit'
      end
    end

    def destroy
      @step = Step.find(params[:id])
      if @step.destroy
        flash[:success] = "ステップが削除されました。"
        redirect_to user_roadmap_steps_url(id: @step, user_id: current_user)
      else
        flash[:error] = "ステップが削除されませんでした。"
      rrender 'index'
      end
    end

    private
  
      def step_params
        params.require(:step).permit(:name, :content)
      end

      def correct_user
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = @roadmap.steps.find_by(id: params[:id])
        redirect_to root_url if @step.nil?
      end

end
