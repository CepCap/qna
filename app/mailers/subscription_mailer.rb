class SubscriptionMailer < ApplicationMailer
  def subscription(question, user)
    @user = user
    @question = question

    mail to: user.email
  end
end
