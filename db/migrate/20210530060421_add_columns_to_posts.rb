class AddColumnsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :url_title, :text
    add_column :posts, :url_description, :text
    add_column :posts, :url_image, :text
  end
end
