class UsersController < ApplicationController
  require "prawn"

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created'
    else
      render 'new'
    end
    # render plain: params[:user].inspect
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
    # raise params.inspect
    @user = User.find(params[:id])
  end

  def generate_pdf
    @user = User.find(params[:id])

    pdf_text = @user.build_pdf_text

    pdf = Prawn::Document.new
    pdf.text pdf_text
    pdf.render_file "resume.pdf"

    send_data pdf.render,
              filename: "resume.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :phone, :email, :skype_name, :job_description, :avatar)
  end
end
