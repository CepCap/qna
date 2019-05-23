class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.created_today

    mail to: user.email
  end
end
