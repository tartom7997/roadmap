class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  impressionist :actions=> [:show]

  def index
    # @users = User.all
    # @users = User.paginate(page: params[:page])
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    #debugger
    @microposts = @user.microposts.paginate(page: params[:page])
    @roadmap  = @user.roadmaps.order(updated_at: :desc).first
    # @id = User.id
    # @name = User.name
    # @picture = User.picture
    # @profile = User.profile
    # @videos = User.videos.order("created_at DESC")
    @my_post = @user.feed_my_post.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    impressionist(@user, nil, unique: [:session_hash])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "アカウントを有効化のためのメールを送信します。数分後にメールをチェックしてください。迷惑メールに入っていないかもご注意ください。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    # @picture = User.picture
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "プロフィールが更新されました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

# sign_up sns

  def new_sns
    auth = request.env['omniauth.auth']
    if auth.present?      # 認証情報があるなら
      @user = User.find_or_initialize_from_auth(request.env['omniauth.auth'])
      if @user.activated?
        @user.save
        log_in @user
        flash[:success] = "ユーザー認証が完了しました。"
        redirect_back_or @user
      else
        flash[:success] = "ユーザー登録情報を入力して下さい。"
        @user = User.find_or_initialize_from_auth(request.env['omniauth.auth'])
      end
    end
  end

  def create_sns
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "アカウントを有効化のためのメールを送信します。数分後にメールをチェックしてください。迷惑メールに入っていないかもご注意ください。"
      redirect_to root_url
    else
      render 'new_sns'
    end
  end

  def like_roadmaps
    @like_roadmap  = current_user.like_roadmaps.includes(:user).paginate(page: params[:page], per_page: 10)
  end

  def like_posts
    @like_post = current_user.like_posts.includes(:post => {:step => {:roadmap => :user}}).paginate(page: params[:page], per_page: 10)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,
                                   :gender, :birthday, :profile, :picture,
                                   :provider, :uid, :agreement)
    end

    # beforeアクション
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end