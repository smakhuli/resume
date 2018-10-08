class CreateResumeLists < ActiveRecord::Migration[5.2]
  def change
    create_table :resume_lists do |t|
      t.string :list_type
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
