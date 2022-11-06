class CreateLicenses < ActiveRecord::Migration[7.0]
  def change
    create_table :licenses do |t|
      t.string :key
      t.integer :status

      t.timestamps
    end
  end
end
