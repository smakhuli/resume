class EmploymentRecord < ApplicationRecord
  belongs_to :user

  validates :employer_name, :start_date, :job_title, :job_description, presence: true

end
