class CreateParametersClients < ActiveRecord::Migration[7.0]
  def change
    create_table :parameters_clients do |t|
      t.references :client, null: false, foreign_key: true
      t.references :parameter, null: false, foreign_key: true

      t.index [:client, :parameter], unique: true

      t.timestamps
    end
  end
end
