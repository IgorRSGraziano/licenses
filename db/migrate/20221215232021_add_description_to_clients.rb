class AddDescriptionToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :description, :string
  end
end
