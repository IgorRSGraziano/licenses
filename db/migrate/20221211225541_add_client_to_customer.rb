class AddClientToCustomer < ActiveRecord::Migration[7.0]

  def change
    default_client = Client.first.try(:id) || Client.create.id
    add_reference :customers, :client, null: false, foreign_key: true, default: default_client
    change_column_default :customers, :client_id, nil
  end
end
