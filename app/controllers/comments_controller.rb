class CommentsController < ApplicationController
  before_action :authenticate_user!

  expose :commentable, -> { Object.const_get(params[:commentable_type]).find(params[:commentable_id]) }

  after_action :publish_comment, only: [:create]

  def create
    @comment = commentable.comments.create(body: comment_params[:body], user: current_user)
  end

  private

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast("question_#{find_question}", @comment.to_json)
  end

  def find_question
    if commentable.is_a? Answer
      commentable.question.id
    else
      commentable.id
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
