class AddClientToLicenses < ActiveRecord::Migration[7.0]
  def change
    add_reference :licenses, :client, null: false, foreign_key: true
  end
end
