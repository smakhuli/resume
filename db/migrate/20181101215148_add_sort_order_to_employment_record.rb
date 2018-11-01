class AddSortOrderToEmploymentRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :employment_records, :sort_order, :integer
  end
end
