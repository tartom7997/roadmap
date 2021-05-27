class CreateHashtagPostRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :hashtag_post_relations do |t|
      t.references :post, null: false, foreign_key: true
      t.references :hashtag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
