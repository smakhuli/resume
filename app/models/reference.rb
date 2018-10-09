class Reference < ApplicationRecord
  belongs_to :user

  validates :reference_name, :email, :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

end
