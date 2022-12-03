class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :brand
      t.string :token

      t.index :token, unique: true

      t.timestamps
    end
  end
end
