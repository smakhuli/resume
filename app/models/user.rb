class User < ApplicationRecord
  has_one :profile
  has_many :employment_records
  has_many :resume_lists
  has_many :references

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

  def destroy_other_resume_info
    # Delete profile if one exists for user
    if self.profile.present?
      self.profile.destroy
    end

    # Delete employement records if any exist for user
    self.employment_records.each do |employment_record|
      employment_record.destroy
    end

    # Delete resume lists if any exist for user
    self.resume_lists.each do |resume_list|
      resume_list.destroy
    end

    # Delete references if any exist for user
    self.references.each do |reference|
      reference.destroy
    end
  end

  def build_pdf_text
    pdf_text = self.full_name
    pdf_text += "\n\n"

    if self.profile.present?
      pdf_text += self.profile.address1
      pdf_text += "\n"

      if self.profile.address2.present?
        pdf_text += self.profile.address2
        pdf_text += "\n"
      end

      pdf_text += "#{self.profile.city}, #{self.profile.state}, #{self.profile.zip_code}"
    end

    pdf_text
  end
end
