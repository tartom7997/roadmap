class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :url
      t.string :url_title
      t.string :category
      t.references :step, null: false, foreign_key: true

      t.timestamps
    end
  end
end