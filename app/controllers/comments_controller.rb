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
    ActionCable.server.broadcast('comments', @comment.to_json)
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id)
  end
end
