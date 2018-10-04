class User < ApplicationRecord
  has_one :profile

  validates :first_name, :last_name, :email, :job_description, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  mount_uploader :avatar, AvatarUploader

  def full_name
    [first_name, middle_name, last_name].select(&:present?).join(' ').titleize
  end

  def remove_avatar_image
    self.remove_avatar!
    self.save!
  end
end
