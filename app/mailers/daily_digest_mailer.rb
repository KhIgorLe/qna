class DailyDigestMailer < ApplicationMailer

  def digest(user)
    @greeting = "Hi"
    @questions = Question.today

    mail to: user.email
  end
end
