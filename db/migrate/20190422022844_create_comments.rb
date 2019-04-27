class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :user, foreign_key: { to_table: :users }
      t.belongs_to :commentable, polymorphic: true

      t.timestamps
    end
  end
end
