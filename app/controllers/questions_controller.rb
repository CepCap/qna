class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question
  expose :answer, -> { Answer.new }

  def show
    @author = current_user.is_author?(question) if user_signed_in?
  end

  def create
    @question = current_user.created_questions.create(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    if question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      render :question
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
