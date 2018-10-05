class EmploymentRecordsController < ApplicationController

  def index
    @user_id = params[:user_id]
    @employment_records = EmploymentRecord.my_employment_records(@user_id)
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
      redirect_to user_path(@user_id)
    else
      render 'new'
    end
  end

  def update
    @user_id = params[:employment_record][:user_id]
    @employment_record = EmploymentRecord.find(params[:id])

    if @employment_record.update(employment_record_params)
      redirect_to user_path(@user_id)
    else
      render 'edit'
    end
  end

  def destroy
    @user_id = params[:user_id]
    @employment_record = EmploymentRecord.find(params[:id])
    @employment_record.destroy

    redirect_to employment_records_path(user_id: @user_id)
  end

  private

  def employment_record_params
    params.require(:employment_record).permit(:employer_name, :start_date, :end_date, :job_title, :job_description, :user_id)
  end
end
