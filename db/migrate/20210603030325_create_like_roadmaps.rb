class CreateLikeRoadmaps < ActiveRecord::Migration[6.1]
  def change
    create_table :like_roadmaps do |t|
      t.integer     :user_id
      t.integer     :roadmap_id
      t.timestamps
    end
  end
end
