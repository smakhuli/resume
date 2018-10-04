class User < ApplicationRecord
  validates :first_name, :last_name, :email, :job_description, presence: true

end
