class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def create
    @answer = question.answers.create(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def update
    if current_user.author_of?(answer)
      if answer.update(answer_params)
        redirect_to answer.question, notice: 'Your answer successfully updated.'
      else
        render 'questions/show'
      end
    else
      redirect_to answer.question, notice: "You're not an author of this question"
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      render 'questions/show', notice: 'Your answer successfully deleted.'
    else
      render 'questions/show', notice: "You're not an author"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
