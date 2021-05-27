class Hashtag < ApplicationRecord
    validates :hashname, presence: true, length: { maximum: 50 }
    has_many :hashtag_roadmap_relations, dependent: :destroy
    has_many :roadmaps, through: :hashtag_roadmap_relations
    has_many :hashtag_post_relations, dependent: :destroy
    has_many :posts, through: :hashtag_post_relations
end
