class ReportMailer < ApplicationMailer

  def send_report(user, answer)
    @greeting = "Hi"
    @answer = answer

    mail to: user.email
  end
end
