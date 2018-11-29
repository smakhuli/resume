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

    if user_signed_in?
      unless @profile.is_owned_by?(current_user) || current_user.is_admin?
        redirect_to users_path, alert: 'You do not have authority to edit this profile'
      end
    else
      redirect_to users_path, alert: 'You do not have authority to edit this profile'
    end

  end

  def create
    @user_id = params[:profile][:user_id]
    @profile = Profile.new(profile_params)

    if @profile.save
      redirect_to user_path(@user_id), notice: 'Profile was successfully created'
    else
      @user = User.find(@user_id)
      render 'new'
    end
  end

  def update
    @user_id = params[:profile][:user_id]
    @profile = Profile.find(params[:id])

    if @profile.update(profile_params)
      redirect_to user_path(@user_id), notice: 'Profile was successfully updated'
    else
      render 'edit'
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    redirect_to users_path, alert: 'Profile was deleted'
  end

  private

  def profile_params
    params.require(:profile).permit(:address1, :address2, :city, :state, :zip_code, :phone, :skype_name, :job_description, :user_id)
  end
end

