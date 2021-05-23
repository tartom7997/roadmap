class Step < ApplicationRecord
  belongs_to :roadmap
  default_scope -> { order(created_at: :ASC) }
  validates :roadmap_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 250 }
  has_many :posts, dependent: :destroy
end
