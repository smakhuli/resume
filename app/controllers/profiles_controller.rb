class ProfilesController < ApplicationController

  def new
    @user_id = params[:user_id]
    @user = User.find(@user_id)
    @profile = Profile.new
  end

  def edit
    @user_id = params[:user_id]
    @profile = Profile.find(params[:id])
    @user = @profile.user
  end

  def create
    @user_id = params[:profile][:user_id]
    @profile = Profile.new(profile_params)

    if @profile.save
      redirect_to user_path(@user_id)
    else
      render 'new'
    end
  end

  def update
    @user_id = params[:profile][:user_id]
    @profile = Profile.find(params[:id])

    if @profile.update(profile_params)
      redirect_to user_path(@user_id)
    else
      render 'edit'
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    redirect_to users_path
  end

  private

  def profile_params
    params.require(:profile).permit(:address1, :address2, :city, :state, :zip_code, :user_id)
  end
end

