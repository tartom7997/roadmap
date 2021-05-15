class RemoveStatusFromSteps < ActiveRecord::Migration[6.1]
  def change
    remove_column :steps, :status, :string
  end
end
