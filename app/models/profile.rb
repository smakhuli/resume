class Profile < ApplicationRecord
  belongs_to :user

  validates :address1, :city, :state, :zip_code, presence: true

end
