class EmploymentRecordsController < ApplicationController

  def index
    @user_id = params[:user_id]

    if user_signed_in?
      if current_user.id == @user_id.to_i || current_user.is_admin?
        @employment_records = User.find_by_id(@user_id).employment_records.order(:sort_order) if User.find_by_id(@user_id).present?
      else
        redirect_to users_path, alert: 'You do not have authority to edit these employment records'
      end
    else
      redirect_to users_path, alert: 'You do not have authority to edit these employment records'
    end

  end

  def new
    @user_id = params[:user_id]
    @employment_record = EmploymentRecord.new
  end

  def edit
    @user_id = params[:user_id]

    if user_signed_in?
      if current_user.id == @user_id.to_i || current_user.is_admin?
        @employment_record = EmploymentRecord.find(params[:id])
      else
        redirect_to users_path, alert: 'You do not have authority to edit this employment record'
      end
    else
      redirect_to users_path, alert: 'You do not have authority to edit this employment record'
    end

  end

  def create
    @user_id = params[:employment_record][:user_id]
    @employment_record = EmploymentRecord.new(employment_record_params)

    if @employment_record.save
      redirect_to employment_records_path(user_id: @user_id), notice: 'Employement Record was successfully created'
    else
      render 'new'
    end
  end

  def update
    @user_id = params[:employment_record][:user_id]
    @employment_record = EmploymentRecord.find(params[:id])

    if @employment_record.update(employment_record_params)
      redirect_to employment_records_path(user_id: @user_id), notice: 'Employement Record was successfully updated'
    else
      render 'edit'
    end
  end

  def destroy
    @user_id = params[:user_id]
    @employment_record = EmploymentRecord.find(params[:id])
    @employment_record.destroy

    redirect_to employment_records_path(user_id: @user_id), alert: 'Employement Record was deleted'
  end

  private

  def employment_record_params
    params.require(:employment_record).permit(:employer_name, :start_date, :end_date, :job_title, :job_description, :user_id, :sort_order)
  end
end
