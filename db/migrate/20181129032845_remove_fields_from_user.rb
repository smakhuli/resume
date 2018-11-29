class RemoveFieldsFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :skype_name, :string
    remove_column :users, :phone, :string
    remove_column :users, :job_description, :text
  end
end
