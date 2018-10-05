class EmploymentRecord < ApplicationRecord
  belongs_to :user

  validates :employer_name, :start_date, :job_title, :job_description, presence: true

  def self.my_employment_records(user_id)
    where("user_id = ?", user_id)
  end
end
