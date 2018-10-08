class ResumeListsController < ApplicationController
  def index
    @user_id = params[:user_id]
  end

  def new
    @user_id = params[:user_id]
    @resume_list_item = ResumeList.new
  end

  def edit
    @user_id = params[:user_id]
    @resume_list_item = ResumeList.find(params[:id])
  end

  def create
    @user_id = params[:resume_list][:user_id]
    @resume_list_item = ResumeList.new(resume_list_params)

    if @resume_list_item.save
      redirect_to user_path(@user_id)
    else
      render 'new'
    end
  end

  def update
    @user_id = params[:resume_list][:user_id]
    @resume_list_item = ResumeList.find(params[:id])

    if @resume_list_item.update(resume_list_params)
      redirect_to resume_lists_path(user_id: @user_id)
    else
      render 'edit'
    end
  end

  def destroy
    @user_id = params[:user_id]
    @resume_list_item = ResumeList.find(params[:id])
    @resume_list_item.destroy

    redirect_to resume_lists_path(user_id: @user_id)
  end

  private

  def resume_list_params
    params.require(:resume_list).permit(:list_type, :description, :user_id)
  end

end
