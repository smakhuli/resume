class EmploymentRecordsController < ApplicationController

  def index
    @user_id = params[:user_id]
    @employment_records = User.find_by_id(@user_id).employment_records.order(:sort_order) if User.find_by_id(@user_id).present?
  end

  def new
    @user_id = params[:user_id]
    @employment_record = EmploymentRecord.new
  end

  def edit
    @user_id = params[:user_id]
    @employment_record = EmploymentRecord.find(params[:id])
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
