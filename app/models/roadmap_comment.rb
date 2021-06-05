class RoadmapComment < ApplicationRecord
  belongs_to :user
  belongs_to :roadmap
  validates :comment_content, presence: true, length: { maximum: 250 }

end
