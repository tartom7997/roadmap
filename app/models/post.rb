class Post < ApplicationRecord
  before_save { self.hashbody = hashbody.downcase }
  belongs_to :step
  belongs_to :category
  validates :step_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true
  validates :url, presence: true
  validates :hashbody, presence: true, length: { maximum: 50 }, format: { without: /＃/, message: ' # は半角で入力してください' }
  validates :hashbody, format: { without: /[０-９]/, message: 'の数字は半角で入力してください' }
  has_rich_text :content
  has_many :hashtag_post_relations, dependent: :destroy
  has_many :hashtags, through: :hashtag_post_relations

  after_create do
    post = Post.find_by(id: id)
    # hashbodyに打ち込まれたハッシュタグを検出
    hashtags = hashbody.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      # ハッシュタグは先頭の#を外した上で保存
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.hashtags << tag
    end
  end
  #更新アクション
  before_update do
    post = Post.find_by(id: id)
    post.hashtags.clear
    hashtags = hashbody.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      post.hashtags << tag
    end
  end

end
