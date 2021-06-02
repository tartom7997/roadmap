class StepsController < ApplicationController
    before_action :logged_in_user, only: [:new, :create]
    before_action :correct_admin_user,   only: [:edit, :update, :destroy]
  
    def index
      @user = User.find(params[:user_id])
      @roadmap = Roadmap.find(params[:roadmap_id])
      @steps = @roadmap.steps.paginate(page: params[:page], per_page: 5).order("created_at ASC")
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
            flash[:success] = "ステップが作成されました！"
            redirect_to user_roadmap_steps_path(@user, @roadmap)
        else
            flash[:danger] = "ステップの作成に失敗しました。"
            @steps = @roadmap.steps.paginate(page: params[:page], per_page: 5).order("created_at ASC")
            render 'index'
        end
    end

    def edit
    end

    def update
      @step = Step.find(params[:id])
      if @step.update(step_params)
        # 更新に成功した場合を扱う。
        flash[:success] = "ステップが更新されました。"
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
        @steps = @roadmap.steps.paginate(page: params[:page], per_page: 5).order("created_at ASC")
        render 'index'
      end
    end

    private
  
      def step_params
        params.require(:step).permit(:name, :content)
      end

      # 210601_correct_admin_userに変更
      def correct_user
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = @roadmap.steps.find_by(id: params[:id])
        redirect_to root_url if @step.nil?
      end

      def correct_admin_user
        @user = User.find(params[:user_id])
        @roadmap = Roadmap.find(params[:roadmap_id])
        @step = @roadmap.steps.find_by(id: params[:id])
        if current_user == @user || current_user.admin
          true
        else
          false
          redirect_to(root_url)
        end
      end

end
