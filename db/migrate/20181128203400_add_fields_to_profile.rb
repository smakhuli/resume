class AddFieldsToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :skype_name, :string
    add_column :profiles, :phone, :string
    add_column :profiles, :job_description, :text
  end
end
