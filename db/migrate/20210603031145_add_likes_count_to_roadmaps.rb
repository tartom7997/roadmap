class AddLikesCountToRoadmaps < ActiveRecord::Migration[6.1]
  def change
    add_column :roadmaps, :likes_count, :integer
  end
end
