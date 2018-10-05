class CreateEmploymentRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :employment_records do |t|
      t.string :employer_name
      t.date :start_date
      t.date :end_date
      t.string :job_title
      t.text :job_description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
