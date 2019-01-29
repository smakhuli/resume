class ReferencesController < ApplicationController

  def index
    @user_id = params[:user_id]

    if user_signed_in? && current_user.has_access?(@user_id.to_i)
        @references = User.find_by_id(@user_id).references.order(:sort_order) if User.find_by_id(@user_id).present?
    else
      redirect_to users_path, alert: 'You do not have authority to edit these references'
    end

  end

  def new
    @user_id = params[:user_id]
    @reference = Reference.new
  end

  def edit
    @user_id = params[:user_id]

    if user_signed_in? && current_user.has_access?(@user_id.to_i)
        @reference = Reference.find(params[:id])
    else
      redirect_to users_path, alert: 'You do not have authority to edit this reference'
    end

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
    params.require(:reference).permit(:reference_name, :email, :phone, :description, :user_id, :sort_order)
  end

end
