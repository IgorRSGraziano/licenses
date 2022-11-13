class License < ApplicationRecord
  enum status: { active: 0, inactive: 1, suspended: 2 }
  belongs_to :customer
  belongs_to :payment
end
