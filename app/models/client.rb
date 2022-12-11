class Client < ApplicationRecord
  has_many :parameters_clients

  def param(identifier)
    Parameter.find_by identifier:
  end
end
