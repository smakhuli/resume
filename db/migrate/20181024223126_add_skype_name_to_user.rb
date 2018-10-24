class AddSkypeNameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :skype_name, :string
  end
end
