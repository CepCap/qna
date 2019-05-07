class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.string :uid
      t.string :provider

      t.references :user, foreign_key: { to_table: :users }
    end

    add_index :authorizations, :provider
    add_index :authorizations, :uid
  end
end
