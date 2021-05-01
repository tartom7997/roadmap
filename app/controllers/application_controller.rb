class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :detect_device

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    def detect_device
      case request.user_agent
        when /iPad/
            request.variant = :mobile
        when /iPod/
            request.variant = :mobile
        when /iPhone/
            request.variant = :mobile
        when /Android/
            request.variant = :mobile
      end
    end

end