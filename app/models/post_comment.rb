class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :comment_content, presence: true, length: { maximum: 250 }
  
end
