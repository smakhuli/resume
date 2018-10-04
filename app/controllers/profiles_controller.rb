class ProfilesController < ApplicationController

  def new
    @user_id = params[:user_id]
    @profile = Profile.new
  end

  def edit
    @user_id = params[:user_id]
    @profile = Profile.find(params[:id])
  end

  def create
    @user_id = params[:profile][:user_id]
    @profile = Profile.new(profile_params)

    if @profile.save
      redirect_to users_path
    else
      render 'new'
    end
  end

  def update
    @user_id = params[:profile][:user_id]
    @profile = Profile.find(params[:id])

    if @profile.update(profile_params)
      redirect_to users_path
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

