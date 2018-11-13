class ResumeList < ApplicationRecord
  LIST_TYPES = ['Education', 'OJT', 'Award', 'Skill', 'Activity']
  LIST_DIV_HEADERS = ['education', 'ojt', 'awards', 'skills', 'activities']
  LIST_TITLES = ['Education', 'On The Job Experience', 'Awards', 'Skills', 'Activities']

  belongs_to :user

  validates :list_type, :description, presence: true

  def self.my_resume_list_by_type(user_id, list_type)
    where("user_id = ? and list_type = ?", user_id, list_type)
  end

  def self.my_resume_list(user_id)
    where("user_id = ?", user_id)
  end

end
