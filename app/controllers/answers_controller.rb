class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def create
    @answer = question.answers.create(answer_params)
    if @answer.save
      redirect_to question, notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
