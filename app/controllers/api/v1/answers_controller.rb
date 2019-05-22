class Api::V1::AnswersController < Api::V1::BaseController
  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer, -> { Answer.find(params[:id]) }
  
  authorize_resource

  def index
    render json: question.answers
  end

  def show
    render json: answer
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @answer.save
      render json: @answer, status: :created
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if answer.update(answer_params)
      render json: answer, status: :ok
    else
      render json: answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
