class ChangeHashtagRelationsToHashtagRoadmapRelations < ActiveRecord::Migration[6.1]
  def change
    rename_table :hashtag_relations, :hashtag_roadmap_relations
  end
end
