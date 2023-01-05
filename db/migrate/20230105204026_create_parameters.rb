class CreateParameters < ActiveRecord::Migration[7.0]
  def change
    create_table :parameters do |t|
      t.string :identifier
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
