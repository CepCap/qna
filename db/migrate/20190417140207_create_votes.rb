class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.boolean :vote_type, null: false
      t.belongs_to :user, foreign_key: { to_table: :users }
      t.belongs_to :voteable, polymorphic: true

      t.timestamps
    end
  end
end
