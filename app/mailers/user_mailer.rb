class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "【Growhtmap】アカウントの有効化について"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "【Growhtmap】パスワードの再設定について"
  end

  def email_reset(user)
    @user = user
    mail to: user.email_reset_before, subject: "【Growhtmap】Eメールアドレスの再設定について"
  end

end
