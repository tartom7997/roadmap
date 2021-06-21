class AddImpressionsCountToSteps < ActiveRecord::Migration[6.1]
  def change
    add_column :steps, :impressions_count, :integer, default: 0
  end
end
