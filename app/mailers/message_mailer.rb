class MessageMailer < ApplicationMailer
  def contact_email
    @message = params[:message]
    mail(to: 'sami.resume.builder@gmail.com', subject: "Message from #{@message.name}")
  end
end
