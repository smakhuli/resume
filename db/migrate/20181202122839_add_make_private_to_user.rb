class AddMakePrivateToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :make_private, :boolean, default: false
  end
end
