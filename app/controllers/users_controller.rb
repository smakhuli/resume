class UsersController < ApplicationController
  require "prawn"
  # before_action :authenticate_user!

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
    @user = User.find(params[:id])

    if user_signed_in?
      unless current_user.is_owner?(@user) || current_user.is_admin?
        redirect_to users_path, alert: 'You do not have authority to edit this user'
      end
    else
      redirect_to users_path, alert: 'You do not have authority to edit this user'
    end
  end

  def show
    @user = User.find(params[:id])
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
    @user = User.find(params[:id])

    if @user.update(user_params)
      @user.remove_avatar_image if params[:user][:remove_avatar] == '1' && @user.avatar.url.present?

      redirect_to @user, notice: 'User was successfully updated'
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])

    @user.destroy_other_resume_info

    @user.destroy

    redirect_to users_path, alert: 'User was deleted'
  end

  def show_resume
    @user = User.find(params[:id])
  end

  def generate_pdf
    @user = User.find(params[:id])

    pdf = @user.build_resume_pdf

    send_data pdf.render,
              filename: "resume.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :email, :role, :make_private, :avatar)
  end
end
