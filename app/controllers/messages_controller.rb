class MessagesController < ApplicationController

  def index
    if user_signed_in?
      if current_user.is_app_owner?
        @messages = Message.all
      else
        redirect_to users_path, alert: 'You do not have the authority to access messages'
      end
    else
      redirect_to users_path, alert: 'You do not have the authority to access messages'
    end
  end

  def new
    @message = Message.new
  end

  def edit
    @message = Message.find(params[:id])
  end

  def show
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      MessageMailer.with(message: @message).contact_email.deliver_now

      redirect_to users_path, notice: 'Message was successfully sent'
    else
      render 'new'
    end
  end

  def update
    @message = Message.find(params[:id])

    if @message.update(message_params)
      # Send Mailer

      redirect_to users_path, notice: 'Message was successfully sent'
    else
      render 'edit'
    end
  end

  def destroy
    @message = Message.find(params[:id])

    @message.destroy

    redirect_to messages_path, alert: 'Message was deleted'
  end

  private

  def message_params
    params.require(:message).permit(:name, :email, :body)
  end

end