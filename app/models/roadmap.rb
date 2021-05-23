class Roadmap < ApplicationRecord
    belongs_to :user
    mount_uploader :picture, PictureUploader
    validates :user_id, presence: true
    validates :title, presence: true, length: { maximum: 50 }
    validates :purpose, presence: true, length: { maximum: 100 }
    validates :target, presence: true, length: { maximum: 100 }
    has_many :steps, dependent: :destroy

    private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "５MBよりサイズを小さくしてください。")
      end
    end


end
