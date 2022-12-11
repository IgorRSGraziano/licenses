class ParametersClient < ApplicationRecord
  belongs_to :client_id
  belongs_to :parameter_id
end
