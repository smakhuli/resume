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

  def build_resume_pdf
    pdf = Prawn::Document.new

    pdf.font_size 20
    pdf.text self.full_name, align: :center, style: :bold
    pdf.font_size 12
    pdf.text "\n"

    if self.profile.present?
      pdf.text self.profile.address1, align: :center

      if self.profile.address2.present?
        pdf.text self.profile.address2, align: :center
      end

      pdf.text "#{self.profile.city}, #{self.profile.state}, #{self.profile.zip_code}", align: :center
      pdf.text "\n"
    end

    if self.phone.length == 10
      pdf.text "#{self.format_phone(self.phone)}", align: :center
    else
      pdf.text "#{self.phone}", align: :center
    end

    pdf.text self.email, align: :center
    pdf.text "\n"

    pdf.font_size 16
    pdf.text "Objective", style: :bold
    pdf.font_size 12
    pdf.text "\n"

    sections = self.split_text(self.job_description)
    sections.each do |section|
      unless section.blank?
        pdf.text self.sanitize_text(section)
        pdf.text "\n"
      end
    end

    # Display Employment History
    pdf.font_size 20
    pdf.text "Employment History", style: :bold
    pdf.text "\n"
    self.employment_records.order(:sort_order).each do |employment_record|
      pdf.font_size 16
      pdf.text employment_record.employer_name, style: :bold
      pdf.font_size 12
      pdf.text employment_record.start_date.strftime("%B %Y") + " - " + employment_record.format_end_date
      pdf.text employment_record.job_title
      pdf.text "\n"

      pdf.text "Job Description", style: :bold
      sections = self.split_text(employment_record.job_description)
      sections.each do |section|
        unless section.blank?
          pdf.text self.sanitize_text(section)
          pdf.text "\n"
        end
      end

      pdf.text "\n"
    end

    # Display Resume List
    ResumeList::LIST_TYPES.each_with_index do |list_type, index|

      if ResumeList.my_resume_list_by_type(self.id, list_type).any?
        pdf.text "\n"

        pdf.font_size 16
        pdf.text "#{ResumeList::LIST_TITLES[index]}", style: :bold
        pdf.font_size 12

        ResumeList.my_resume_list_by_type(self.id, list_type).each do |resume_list_item|
          pdf.text "- #{resume_list_item.description}"
        end
      end
    end
    pdf.text "\n"

    # Display References
    if self.references.any?
      pdf.font_size 20
      pdf.text "References", style: :bold
      pdf.text "\n"

      self.references.order(:sort_order).each do |reference|
        pdf.font_size 16
        pdf.text reference.reference_name, style: :bold
        pdf.font_size 12

        pdf.text reference.email

        if reference.phone.length == 10
          pdf.text "#{self.format_phone(reference.phone)}"
        else
          pdf.text "#{reference.phone}"
        end

        pdf.text "\n"
        sections = self.split_text(reference.description)
        sections.each do |section|
          unless section.blank?
            pdf.text self.sanitize_text(section)
            pdf.text "\n"
          end
        end
      end
    else
      pdf.font_size 16
      pdf.text "References available upon request."
    end

    # pdf.render_file "resume.pdf"

    pdf
  end

  def format_phone(phone_number)
    "(" + phone_number[0..2] + ") " + phone_number[3..5] + "-" + phone_number[6..9]
  end

  def split_text(text)
    text.split("<br>")
  end

  def sanitize_text(text)
    ActionView::Base.full_sanitizer.sanitize(text)
  end
end
