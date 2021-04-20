class AddPictureToRoadmaps < ActiveRecord::Migration[6.1]
  def change
    add_column :roadmaps, :picture, :string
  end
end
