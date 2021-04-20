class Roadmap < ApplicationRecord
    belongs_to :user
    # default_scope -> { order(created_at: :desc) }
    mount_uploader :picture, PictureUploader
    validates :user_id, presence: true
    validates :title, presence: true, length: { maximum: 50 }
    validates :purpose, presence: true, length: { maximum: 100 }
    validates :target, presence: true, length: { maximum: 100 }

    private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "５MBよりサイズを小さくしてください。")
      end
    end


end
