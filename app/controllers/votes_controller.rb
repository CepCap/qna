class VotesController < ApplicationController
  before_action :authenticate_user!

  expose :voteable, -> { Object.const_get(vote_params[:voteable_type]).find(vote_params[:voteable_id]) }

  authorize_resource

  def create
    voteable.voting(current_user, vote_params[:vote_type])
    respond_to do |format|
      format.json { render json: { new_count: voteable.vote_count }  }
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:vote_type, :voteable_type, :voteable_id)
  end
end
