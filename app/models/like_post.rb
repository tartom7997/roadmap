class LikePost < ApplicationRecord
    belongs_to :post, counter_cache: :likes_count
    belongs_to :user
end
