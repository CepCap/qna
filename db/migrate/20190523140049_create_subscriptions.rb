class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, foreign_key: { to_table: :users }
      t.belongs_to :question, foreign_key: { to_table: :questions }

      t.timestamps
    end
  end
end
