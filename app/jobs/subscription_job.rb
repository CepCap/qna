class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(question)
    question.subscribed_users.each do |user|
      SubscriptionMailer.subscription(question, user).deliver_later
    end
  end
end
