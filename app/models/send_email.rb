class SendEmail
    require 'sendgrid-ruby'
    include SendGrid
  
    def self.test_email
      from = Email.new(email: 'growthmap.ss@gmail.com') # SendGridの管理画面でSenderに登録したアドレス
      to = Email.new(email: 'growthmap.ss@gmail.com') # 送信したいアドレス
      subject = 'Sending with SendGrid is Fun'
      content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
      mail = Mail.new(from, subject, to, content)
  
      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)
    end

    def self.sendgrid_account_activation(user)
        @user = user
        from = Email.new(email: 'growthmap.ss@gmail.com') # SendGridの管理画面でSenderに登録したアドレス
        to = Email.new(email: @user.email) # 送信したいアドレス
        subject = '【Growhtmap】アカウントの有効化について'
        content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
        mail = Mail.new(from, subject, to, content)

        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
        response = sg.client.mail._('send').post(request_body: mail.to_json)
      end

      def self.deliver_mail_magazine(user)
        mail = Mail.new
        mail.from = Email.new(email: 'growthmap.ss@gmail.com', name: 'growthmap')
        personalization = Personalization.new
        personalization.add_to(Email.new(email: @user.email))
    
        personalization.add_dynamic_template_data(
          subject: '【Growhtmap】アカウントの有効化について',
          name: @user.name,
          body: 'テスト送信だよ'
        )
        mail.add_personalization(personalization)
        mail.template_id = 'd-f5b48bd9664940b7b035878936b91b61'
    
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
        sg.client.mail._('send').post(request_body: mail.to_json)
      end
      
  end