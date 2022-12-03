class AddClientToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :client, null: false, foreign_key: true
  end
end
