class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
    @comment = Comment.new
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
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
      authorize! :pick_best, answer
      answer.choose_best
    else
      redirect_to answer.question, notice: "You're not an author of this question"
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("question_#{question.id}", @answer.to_json)
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
