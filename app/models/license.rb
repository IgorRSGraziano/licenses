class License < ApplicationRecord
  enum status: { active: 0, inactive: 1, suspended: 2 }
  belongs_to :customer, required: false
  belongs_to :payment, required: false

end
