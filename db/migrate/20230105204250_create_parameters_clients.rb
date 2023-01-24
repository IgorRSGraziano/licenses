
class CreateParametersClients < ActiveRecord::Migration[7.0]
  def change
    create_table :parameters_clients do |t|
      t.string :value

      t.references :client, null: false
      t.references :parameter, null: false

      t.index [:client_id, :parameter_id], unique: true

      t.timestamps
    end

    add_foreign_key :parameters_clients, :clients, column: :client_id
    add_foreign_key :parameters_clients, :parameters, column: :parameter_id
  end
end
