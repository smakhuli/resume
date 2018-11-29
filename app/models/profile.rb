class Profile < ApplicationRecord
  belongs_to :user

  validates :address1, :city, :state, :zip_code, :phone, :job_description, presence: true

  def is_owned_by?(user)
    self.user_id == user.id
  end
end
