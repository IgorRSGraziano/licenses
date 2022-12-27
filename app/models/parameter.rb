class Parameter < ApplicationRecord
  has_many :parameters_clients

  def value(client_id)
    ParametersClient.find_by(client_id:, parameter_id: id)&.value
  end
end
