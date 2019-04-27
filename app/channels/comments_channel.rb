class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "question_#{params[:question_id]}"
  end
end
