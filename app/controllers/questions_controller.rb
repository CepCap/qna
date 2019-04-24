class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question
  expose :answer, -> { Answer.new }

  after_action :publish_question, only: [:create]

  def new
    question.links.new
    question.build_award
  end

  def show
    answer.links.new
    @comment = Comment.new
    gon.question_author_id = question.author.id
  end

  def create
    @question = current_user.questions.create(question_params)
    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(question)
      if question.update(question_params)
        redirect_to question
      else
        render :edit
      end
    else
      render :edit, notice: "You're not an author of this question"
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      render :show
    end
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/add_question',
        locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: [:name, :url],
                                     award_attributes: [:name, :image])
  end
end
