class RemovePostIdFromHashtagRoadmapRelation < ActiveRecord::Migration[6.1]
  def change
    remove_column :hashtag_roadmap_relations, :post_id, :string
  end
end
