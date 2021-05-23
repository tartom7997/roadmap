class RemoveUrlTitleFromPost < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :url_title, :string
  end
end
