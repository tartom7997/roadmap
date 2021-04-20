class CreateRoadmaps < ActiveRecord::Migration[6.1]
  def change
    create_table :roadmaps do |t|
      t.string :title
      t.string :object
      t.string :target
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :roadmaps, [:user_id, :created_at]
  end
end
