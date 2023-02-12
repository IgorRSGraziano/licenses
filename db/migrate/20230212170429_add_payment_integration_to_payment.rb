class AddPaymentIntegrationToPayment < ActiveRecord::Migration[7.0]
  def change
    add_reference :payments, :payment_integration, null: false, foreign_key: true
  end
end
