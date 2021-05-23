class Post < ApplicationRecord
  belongs_to :step
  belongs_to :category
  validates :step_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true
  validates :url, presence: true
  has_rich_text :content
end
