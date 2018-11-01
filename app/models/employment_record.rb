class EmploymentRecord < ApplicationRecord
  belongs_to :user

  validates :employer_name, :start_date, :job_title, :job_description, :sort_order, presence: true

  def format_end_date
    return self.end_date.strftime("%B %Y") if self.end_date.present?
    'Present'
  end
end
