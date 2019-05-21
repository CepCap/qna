class Api::V1::QuestionsController < Api::V1::BaseController
  expose :questions, -> { Question.all }
  expose :question, -> { Question.find(params[:id]) }

  authorize_resource

  def index
    render json: questions
  end

  def show
    render json: question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: @question.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question, status: :ok
    else
      render json: question.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
