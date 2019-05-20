class RemoveAuthorFromQuestionAnswer < ActiveRecord::Migration[5.2]
  def change
    remove_reference(:questions, :author)
    remove_reference(:answers, :author)
    add_reference :questions, :user, foreign_key: { to_table: :users }
    add_reference :answers, :user, foreign_key: { to_table: :users }
  end
end
