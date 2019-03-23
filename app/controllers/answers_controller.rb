class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question, -> { Question.find(params[:question_id]) }
  expose :best_answer, -> { Answer.find_by(best: true) }
  expose :answer

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(answer)
      if answer.update(answer_params)
        # redirect_to answer.question, notice: 'Your answer successfully updated.'
      end
    else
      redirect_to answer.question, notice: "You're not an author of this question"
    end
  end

  def destroy
    if current_user.author_of?(answer)
      @id = answer.id
      answer.destroy
    end
  end

  def pick_best
    if current_user.author_of?(question)
      if best_answer
        best_answer.best = nil
        best_answer.save
      end
      answer.best = true
      answer.save
      # redirect_to answer.question, notice: 'You have picked the best answer!'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
