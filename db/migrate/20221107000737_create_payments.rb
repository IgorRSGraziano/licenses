class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :billing_type
      t.string :external_id
      t.integer :installment
      t.decimal :value
      t.string :plan

      t.timestamps
    end
  end
end
