class SessionsController < ApplicationController

  def new
  end

  def create
    # auth = request.env['omniauth.auth']
    # if auth.present?      # 認証情報があるなら
    #   @user = User.find_or_initialize_from_auth(request.env['omniauth.auth'])
    #   @user.save
    #   session[:user_id] = @user.id
    #   if session[:user_id]
    #     flash[:success] = "ユーザー認証が完了しました。"
    #     redirect_back_or @user
    #   else
    #     flash[:danger] = "ユーザー認証に失敗しました。既にEmailでの登録や別のSNSでの登録がされている可能性があります。そちらのログインをお試しいただくか、パスワードの再設定をお試し下さい。"
    #     redirect_to root_url
    #   end
    # else #既存パタン
      @user = User.find_by(email: params[:session][:email].downcase)
      if @user && @user.authenticate(params[:session][:password])
        if @user.activated?
          log_in @user
          params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
          redirect_back_or @user
        else
          message  = "アカウントは有効化されていません。 "
          message += "あなたに送られたメールの有効化リンクをチェックしてみてください。"
          flash[:warning] = message
          redirect_to root_url
        end
      else
        flash.now[:danger] = '無効なemail、もしくはパスワードの組み合わせです。'
        render 'new'
      end
    # end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end