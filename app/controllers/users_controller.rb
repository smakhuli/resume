class UsersController < ApplicationController
  require "prawn"

  before_action :set_user, only: [:show, :edit, :update, :destroy, :show_resume, :generate_pdf]

  def index
    if user_signed_in?
      @users = current_user.get_users
    else
      redirect_to new_user_session_url, alert: 'Please sign up or sign in to access Resumes'
    end
  end

  def new
    @user = User.new
  end

  def edit
    unless user_signed_in? && (current_user.is_owner?(@user) || current_user.is_admin?)
      redirect_to users_path, alert: 'You do not have authority to edit this user'
    end
  end

  def show
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.with(user: @user).welcome_email.deliver_now

      redirect_to @user, notice: 'User was successfully created'
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      # @user.remove_avatar_image if params[:user][:remove_avatar] == '1' && @user.avatar.url.present?

      redirect_to @user, notice: 'User was successfully updated'
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy_other_resume_info

    @user.destroy

    redirect_to users_path, alert: 'User was deleted'
  end

  def show_resume
  end

  def generate_pdf
    pdf = @user.build_resume_pdf

    send_data pdf.render,
              filename: "resume.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :email, :role, :make_private)
  end
end
