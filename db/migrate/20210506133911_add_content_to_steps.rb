class AddContentToSteps < ActiveRecord::Migration[6.1]
  def change
    add_column :steps, :content, :string
  end
end
