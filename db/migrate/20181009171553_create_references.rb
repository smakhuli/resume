class CreateReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :references do |t|
      t.string :reference_name
      t.string :email
      t.string :phone
      t.text :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
