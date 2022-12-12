class AddClientToLicenses < ActiveRecord::Migration[7.0]
  def change
    default_client = Client.first.try(:id) || Client.create.id

    add_reference :licenses, :client, null: false, foreign_key: true, default: default_client
    change_column_default :licenses, :client_id, nil
  end
end
