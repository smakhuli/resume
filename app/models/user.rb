class User < ApplicationRecord
  has_one :profile

  validates :first_name, :last_name, :email, :job_description, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def full_name
    [first_name, middle_name, last_name].select(&:present?).join(' ').titleize
  end

end
