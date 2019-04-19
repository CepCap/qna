class ChangeVoteTypeInVotes < ActiveRecord::Migration[5.2]
  def change
    change_column :votes, :vote_type, :integer, using: 'vote_type::integer'
  end
end
