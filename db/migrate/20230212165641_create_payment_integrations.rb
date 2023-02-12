class CreatePaymentIntegrations < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_integrations do |t|
      t.string :identifier
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
