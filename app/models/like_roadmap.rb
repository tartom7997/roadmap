class LikeRoadmap < ApplicationRecord
    belongs_to :roadmap, counter_cache: :likes_count
    belongs_to :user
end
