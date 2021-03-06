class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  USER_ROLES = ['admin', 'user']

  extend FriendlyId
  friendly_id :full_name, use: :slugged

  has_one :profile
  has_many :employment_records
  has_many :resume_lists
  has_many :references

  validates :first_name, :last_name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # mount_uploader :avatar, AvatarUploader

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

    self.build_profile_section1(pdf) if self.profile.present?

    pdf.text self.email, align: :center

    self.build_profile_section2(pdf) if self.profile.present?

    self.build_employement_records(pdf) if self.employment_records.any?

    self.build_resume_lists(pdf)

    pdf.text "\n"

    if self.references.any?
      self.build_references(pdf)
    else
      pdf.font_size 16
      pdf.text "References available upon request."
    end

    # pdf.render_file "resume.pdf"
    pdf
  end

  def build_profile_section1(pdf)
    pdf.text self.profile.address1, align: :center

    if self.profile.address2.present?
      pdf.text self.profile.address2, align: :center
    end

    pdf.text "#{self.profile.city}, #{self.profile.state}, #{self.profile.zip_code}", align: :center
    pdf.text "\n"

    if self.profile.phone.present?
      if self.profile.phone.length == 10
        pdf.text "#{self.format_phone(self.profile.phone)}", align: :center
      else
        pdf.text "#{self.profile.phone}", align: :center
      end
    end
  end

  def build_profile_section2(pdf)
    if self.profile.skype_name.present?
      pdf.text "Skype Name: #{self.profile.skype_name}", align: :center
      pdf.text "\n"
    else
      pdf.text "\n"
    end

    display_job_description(pdf) if self.profile.job_description.present?
  end

  def display_job_description(pdf)
    pdf.font_size 16
    pdf.text "Objective", style: :bold
    pdf.font_size 12
    pdf.text "\n"

    sections = self.split_text(self.profile.job_description)
    sections.each do |section|
      unless section.blank?
        pdf.text self.sanitize_text(section)
        pdf.text "\n"
      end
    end
  end

  def build_employement_records(pdf)
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
  end

  def build_resume_lists(pdf)
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
  end

  def build_references(pdf)
    pdf.font_size 20
    pdf.text "References", style: :bold
    pdf.text "\n"

    self.references.order(:sort_order).each do |reference|
      pdf.font_size 16
      pdf.text reference.reference_name, style: :bold
      pdf.font_size 12

      pdf.text reference.email

      self.display_phone_number(pdf, reference)

      pdf.text "\n"

      self.display_reference_description(pdf, reference)
    end
  end

  def display_phone_number(pdf, reference)
    if reference.phone.length == 10
      pdf.text "#{self.format_phone(reference.phone)}"
    else
      pdf.text "#{reference.phone}"
    end
  end

  def display_reference_description(pdf, reference)
    sections = self.split_text(reference.description)
    sections.each do |section|
      unless section.blank?
        pdf.text self.sanitize_text(section)
        pdf.text "\n"
      end
    end
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

  def is_owner?(user)
    self == user
  end

  def is_admin?
    self.role == 'admin' || self.email == 'srmakhuli@gmail.com' || self.email == 'roger.makhuli@gmail.com'
  end

  def get_users
    # Put the signed in user at the beginning (position 0) of the user (resume) array
    my_resume = User.find(self.id)

    if self.is_admin?
      other_resumes = User.all.reject { |user| user == my_resume}
    else
      other_resumes = User.public.reject { |user| user == my_resume}
    end

    other_resumes.insert(0, my_resume)
  end

  def self.public
    where('make_private = ?', false)
  end

  def has_access?(user_id)
    self.id == user_id || self.is_admin?
  end
end
