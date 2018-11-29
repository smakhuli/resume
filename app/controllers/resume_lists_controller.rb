class ResumeListsController < ApplicationController
  def index
    @user_id = params[:user_id]

    if user_signed_in?
      unless current_user.id == @user_id.to_i || current_user.is_admin?
        redirect_to users_path, alert: 'You do not have authority to edit these resume lists'
      end
    else
      redirect_to users_path, alert: 'You do not have authority to edit these resume lists'
    end

  end

  def new
    @user_id = params[:user_id]
    @resume_list_item = ResumeList.new
  end

  def edit
    @user_id = params[:user_id]

    if user_signed_in?
      if current_user.id == @user_id.to_i || current_user.is_admin?
        @resume_list_item = ResumeList.find(params[:id])
      else
        redirect_to users_path, alert: 'You do not have authority to edit this resume list item'
      end
    else
      redirect_to users_path, alert: 'You do not have authority to edit this resume list item'
    end


  end

  def create
    @user_id = params[:resume_list][:user_id]
    @resume_list_item = ResumeList.new(resume_list_params)

    if @resume_list_item.save
      redirect_to resume_lists_path(user_id: @user_id), notice: 'Resume list was successfully created'
    else
      render 'new'
    end
  end

  def update
    @user_id = params[:resume_list][:user_id]
    @resume_list_item = ResumeList.find(params[:id])

    if @resume_list_item.update(resume_list_params)
      redirect_to resume_lists_path(user_id: @user_id), notice: 'Resume list was successfully updated'
    else
      render 'edit'
    end
  end

  def destroy
    @user_id = params[:user_id]
    @resume_list_item = ResumeList.find(params[:id])
    @resume_list_item.destroy

    redirect_to resume_lists_path(user_id: @user_id), alert: 'Resume list was deleted'
  end

  private

  def resume_list_params
    params.require(:resume_list).permit(:list_type, :description, :user_id)
  end

end
