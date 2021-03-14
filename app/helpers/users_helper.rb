
module UsersHelper

    # 引数で与えられたユーザーの画像を返す
    def picture_for(user)
      if user.picture?
      image_tag user.picture.thumb_user.url, class: "user-icon2"
      else
      image_tag "/assets/default.png", alt: "user-icon2", class: "user-icon2"
      end
    end
  end