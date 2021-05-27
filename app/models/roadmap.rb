class Roadmap < ApplicationRecord
    before_save { self.hashbody = hashbody.downcase }
    belongs_to :user
    mount_uploader :picture, PictureUploader
    validates :user_id, presence: true
    validates :title, presence: true, length: { maximum: 50 }
    validates :purpose, presence: true, length: { maximum: 100 }
    validates :target, presence: true, length: { maximum: 100 }
    validates :hashbody, presence: true, length: { maximum: 50 }, format: { without: /＃/, message: ' # は半角で入力してください' }
    validates :hashbody, format: { without: /[０-９]/, message: 'の数字は半角で入力してください' }
    has_many :steps, dependent: :destroy
    has_many :hashtag_roadmap_relations, dependent: :destroy
    has_many :hashtags, through: :hashtag_roadmap_relations

    after_create do
      roadmap = Roadmap.find_by(id: id)
      # hashbodyに打ち込まれたハッシュタグを検出
      hashtags = hashbody.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
      hashtags.uniq.map do |hashtag|
        # ハッシュタグは先頭の#を外した上で保存
        tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
        roadmap.hashtags << tag
      end
    end
    #更新アクション
    before_update do
      roadmap = Roadmap.find_by(id: id)
      roadmap.hashtags.clear
      hashtags = hashbody.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
      hashtags.uniq.map do |hashtag|
        tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
        roadmap.hashtags << tag
      end
    end

    private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "５MBよりサイズを小さくしてください。")
      end
    end


end
