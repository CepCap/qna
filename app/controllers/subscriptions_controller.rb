class SubscriptionsController < ApplicationController
  expose :question

  def create
    authorize! :subscribe, question
    current_user.subscribe(question)
  end

  def destroy
    authorize! :unsubscribe, question
    current_user.unsubscribe(question)
  end
end
