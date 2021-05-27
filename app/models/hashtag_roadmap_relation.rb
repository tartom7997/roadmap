class HashtagRoadmapRelation < ApplicationRecord
  belongs_to :roadmap
  belongs_to :hashtag
  validates :roadmap_id, presence: true
  validates :hashtag_id, presence: true
end
