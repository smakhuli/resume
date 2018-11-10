class ReferencesController < ApplicationController

  def index
    @user_id = params[:user_id]
    @references = User.find_by_id(@user_id).references if User.find_by_id(@user_id).present?
  end

  def new
    @user_id = params[:user_id]
    @reference = Reference.new
  end

  def edit
    @user_id = params[:user_id]
    @reference = Reference.find(params[:id])
  end

  def create
    @user_id = params[:reference][:user_id]
    @reference = Reference.new(reference_params)

    if @reference.save
      redirect_to references_path(user_id: @user_id), notice: 'Reference was successfully created'
    else
      render 'new'
    end
  end

  def update
    @user_id = params[:reference][:user_id]
    @reference = Reference.find(params[:id])

    if @reference.update(reference_params)
      redirect_to references_path(user_id: @user_id), notice: 'Reference was successfully updated'
    else
      render 'edit'
    end
  end

  def destroy
    @user_id = params[:user_id]
    @reference = Reference.find(params[:id])
    @reference.destroy

    redirect_to references_path(user_id: @user_id), alert: 'Reference was deleted'
  end

  private

  def reference_params
    params.require(:reference).permit(:reference_name, :email, :phone, :description, :user_id)
  end

end
