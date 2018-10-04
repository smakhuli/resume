class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip_code
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
