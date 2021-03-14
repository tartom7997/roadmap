class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email, unless: :uid?
  before_create :create_activation_digest
  validates :name,  presence: true, unless: :uid?, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, unless: :uid?, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # has_secure_password validations: false # https://qiita.com/tkr_ld/items/e38a5b92866f41087f57
  has_secure_password
  validates :password, presence: true, unless: :uid?, length: { minimum: 6 }, allow_nil: true
  validates :profile, unless: :uid?, length: { maximum: 250 }
  mount_uploader :picture, PictureUploader
  validate  :picture_size

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    # update_attribute(:reset_digest,  User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザーのステータスフィードを返す
  def feed
    # フォローしているユーザーの投稿を含めない
    # Micropost.where("user_id = ?", id)
    # 現在のユーザー自身の投稿を含めない
    # Micropost.where("user_id IN (?) ", following_ids)
    # フォローしているユーザーを含める
    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    # following_ids: following_ids, user_id: id)
    # フォローしていないすべてのユーザーの投稿を含める
    # Micropost.all
    #     following_ids = "SELECT followed_id FROM relationships
    #     WHERE follower_id = :user_id"
    # Micropost.where("user_id IN (#{following_ids})
    #     OR user_id = :user_id", user_id: id)
    # 4. 別の書き方
    Micropost.where(user_id: active_relationships.select(:followed_id))
    .or(Micropost.where(user_id: id))
  end


  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

#auth hashからユーザ情報を取得
#データベースにユーザが存在するならユーザ取得して情報更新する；存在しないなら新しいユーザを作成する
def self.find_or_initialize_from_auth(auth)
  provider = auth[:provider]
  uid = auth[:uid]
  name = auth[:info][:name]
  email = auth[:info][:email]
  remote_picture_url = auth[:info][:image]
  password = Devise.friendly_token[0, 20]
  profile = auth[:info][:description]
  #必要に応じて情報追加してください

  #ユーザはSNSで登録情報を変更するかもしれので、毎回データベースの情報も更新する
  self.find_or_initialize_by(provider: provider, uid: uid) do |user|
    user.name = name
    user.email = email
    user.password = password
    # user.remote_picture_url = remote_picture_url
    user.profile = profile
    user.activated = true

    case provider.to_s
    when 'twitter'
      user.remote_picture_url = remote_picture_url
    when 'google'
      user.remote_picture_url = remote_picture_url
    when 'facebook'
      user.picture = remote_picture_url
    end

  end
end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    email.downcase!
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "５MBよりサイズを小さくしてください。")
      end
    end

  end