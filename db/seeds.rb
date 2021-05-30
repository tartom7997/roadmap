# ユーザー
User.create!(name:  "tomtar9779",
             email: "tomtar9779@gmail.com",
             password:              "kyuunana97",
             password_confirmation: "kyuunana97",
             agreement: true,
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Tester",
             email: "tester@gmail.com",
             password:              "kyuunana97",
             password_confirmation: "kyuunana97",
             agreement: true,
             activated: true,
             activated_at: Time.zone.now)
            

# 99.times do |n|
#   name  = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name:  name,
#                email: email,
#                password:              password,
#                password_confirmation: password,
#                agreement: true,
#                activated: true,
#                activated_at: Time.zone.now) 
# end

# マイクロポスト
# users = User.order(:created_at).take(6)
# 50.times do
#   content = Faker::Lorem.sentence(word_count: 5)
#   users.each { |user| user.microposts.create!(content: content) }
# end

# リレーションシップ
# users = User.all
# user  = users.first
# following = users[2..50]
# followers = users[3..40]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }

# カテゴリー
Category.create!(   
    [               {name:  "本の紹介や書評をする"},
                    {name:  "Podcastや音声から学ぶ"},
                    {name:  "Youtubeや動画から学ぶ"},
                    {name:  "ブログや参考記事から学ぶ"},
                    {name:  "体験談やノウハウをシェアする"}
    ]
                    )