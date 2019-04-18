module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def voting(user, new_vote_type)
    unless user.nil? || user.author_of?(self)
      old_vote = votes.find_by(user_id: user.id)
      ActiveRecord::Base.transaction do
        if old_vote.present?
          if old_vote.vote_type.to_s == new_vote_type
            old_vote.destroy
          else
            old_vote.update(vote_type: new_vote_type)
          end
        else
          vote = votes.create(vote_type: new_vote_type)
          vote.user = user
          vote.save
        end
      end
    end
  end

  def vote_count
    votes.where(vote_type: true).count - votes.where(vote_type: false).count
  end
end
