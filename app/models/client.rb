class Client < ApplicationRecord
  has_many :parameters_clients
  has_many :users

  def param(identifier)
    Parameter.find_by identifier:
  end

  accepts_nested_attributes_for :users
end
