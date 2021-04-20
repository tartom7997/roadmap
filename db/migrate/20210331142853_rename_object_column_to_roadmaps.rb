class RenameObjectColumnToRoadmaps < ActiveRecord::Migration[6.1]
  def change
    rename_column :roadmaps, :object, :purpose
  end
end
