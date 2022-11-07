class AddCustomerToLicenses < ActiveRecord::Migration[7.0]
  def change
    add_reference :licenses, :customer, null: true, foreign_key: true
  end
end
