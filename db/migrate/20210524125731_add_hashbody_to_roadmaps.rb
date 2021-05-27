class AddHashbodyToRoadmaps < ActiveRecord::Migration[6.1]
  def change
    add_column :roadmaps, :hashbody, :string
  end
end
