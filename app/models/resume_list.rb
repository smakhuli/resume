class ResumeList < ApplicationRecord
  LIST_TYPES = ['Activity', 'Award', 'Education', 'Skill', 'OJT']
  LIST_TITLES = ['Activities', 'Awards', 'Education', 'Skills', 'On The Job Experience']

  belongs_to :user

  validates :list_type, :description, presence: true

  def self.my_resume_list_by_type(user_id, list_type)
    where("user_id = ? and list_type = ?", user_id, list_type)
  end

  def self.my_resume_list(user_id)
    where("user_id = ?", user_id)
  end

end
