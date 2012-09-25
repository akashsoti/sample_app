class Verification < ActionMailer::Base
  default from: "akujgd@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.verification.send_link.subject
  #
  
  def send_link(user)
    @greeting = "Hi please verify your email by clicking this link"
    @user = user
    mail to: user.email, subject: "Verification link for sample app"
    
  end
end
