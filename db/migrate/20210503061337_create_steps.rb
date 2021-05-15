class CreateSteps < ActiveRecord::Migration[6.1]
  def change
    create_table :steps do |t|
      t.string :name
      t.references :roadmap, null: false, foreign_key: true

      t.timestamps
    end
  end
end
