class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    @user.save
    redirect_to @user
    # render plain: params[:user].inspect
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :phone, :email, :job_description)
  end
end
