class ParametersClient < ApplicationRecord
  belongs_to :client
  belongs_to :parameter
end
