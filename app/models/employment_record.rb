class EmploymentRecord < ApplicationRecord
  belongs_to :user

  validates :employer_name, :start_date, :job_title, :job_description, :sort_order, presence: true
  validate :end_date_greater_than_start_date

  def format_end_date
    return self.end_date.strftime("%B %Y") if self.end_date.present?
    'Present'
  end

  def end_date_greater_than_start_date
    return if [start_date.blank?, end_date.blank?].any?
    if end_date < start_date
      errors.add(:end_date, 'must be greater than start date')
    end
  end
end
