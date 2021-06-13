class EmailResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # (1) への対応：パスワード再設定の有効期限が切れていないか

  def new
    @user = current_user
  end

  # def create
  #   @user = User.find_by(email: params[:email_reset][:email].downcase)
  #   @user = User.find_by(email_reset_before: params[:email_reset][:email_reset_before].downcase)
  #   if @user
  #     @user.create_reset_digest
  #     @user.send_email_reset_email
  #     # if @user unique?
  #     flash[:info] = "Eメールアドレスの再設定のためのEメールが送られました。"
  #     redirect_to root_url
  #   else
  #     flash.now[:danger] = "Eメールアドレスが見つかりませんでした。"
  #     render 'new'
  #   end
  # end

  # @user = User.find_by(email: params[:session][:email].downcase)
  # if @user && @user.authenticate(params[:session][:password])

  # def create
  #   @user = current_user
  #   User.email_reset_before = email_reset_params[:email]
  #     if User.find_by(email_reset_before: params[:email][:email_reset_before].downcase) != User.select(:email).distinct
  #     @user.create_reset_digest
  #     @user.send_email_reset_email
  #     # if @user unique?
  #     flash[:info] = "Eメールアドレスの再設定のためのEメールが送られました。"
  #     redirect_to root_url
  #   else User.find_by(email: params[:email_reset][:email].downcase) == User.select(:email).distinct
  #     flash.now[:danger] = "Eメールアドレスが見つかりませんでした。"
  #     render 'new'
  #   end
  # end

  def create
    @user = current_user
    if @user
      @user.update(user_params) 
      @user.save
      @user.create_reset_digest
      @user.send_email_reset_email
      flash[:info] = "Eメールアドレスの再設定のためのEメールが送られました。"
      redirect_to mail_send_url
    else
      flash.now[:danger] = "Eメールアドレスが見つかりませんでした。"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?                 # (3) への対応 新しいパスワードが空文字列になっていないか (ユーザー情報の編集ではOKだった)
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif params[:user][:email].empty?
      @user.errors.add(:email, :blank) 
      render 'edit'
    elsif @user.update(user_params)          # (4) への対応 新しいパスワードが正しければ、更新する
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Eメールアドレスが再設定されました。"
      redirect_to @user
    else
      render 'edit'                                     # (2) への対応 無効なパスワードであれば失敗させる (失敗した理由も表示する)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_reset_before, :email, :password)
  end

  # beforeフィルタ

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.email_reset_expired?
        flash[:danger] = "Eメールアドレスの再設定は有効期限切れです。"
        redirect_to new_email_reset_url
      end
    end

end
