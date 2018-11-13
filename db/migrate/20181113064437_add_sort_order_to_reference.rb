class AddSortOrderToReference < ActiveRecord::Migration[5.2]
  def change
    add_column :references, :sort_order, :integer
  end
end
