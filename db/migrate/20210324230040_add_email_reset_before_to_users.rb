class AddEmailResetBeforeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :email_reset_before, :string
  end
end
