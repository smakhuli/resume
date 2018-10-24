class UsersController < ApplicationController
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
      redirect_to @user
    else
      render 'new'
    end
    # render plain: params[:user].inspect
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      @user.remove_avatar_image if params[:user][:remove_avatar] == '1' && @user.avatar.url.present?

      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])

    # Delete profile if one exists for user
    if @user.profile.present?
      @user.profile.destroy
    end

    @user.destroy

    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :phone, :email, :skype_name, :job_description, :avatar)
  end
end
