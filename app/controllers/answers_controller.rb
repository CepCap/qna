class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def create
    @answer = question.answers.create(answer_params)
    @answer.author = current_user
    if @answer.save
      render 'questions/show', notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def update
    if current_user.is_author? answer
      if answer.update(answer_params)
        redirect_to 'questions/show', notice: 'Your answer successfully updated.'
      else
        render :edit
      end
    else
      render :edit, notice: "You're not an author of this question"
    end
  end

  def destroy
    if current_user.is_author?(answer)
      answer.destroy
      render 'questions/show', notice: 'Your answer successfully deleted.'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
