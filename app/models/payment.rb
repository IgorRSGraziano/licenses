class Payment < ApplicationRecord
  has_one :license
  belongs_to :payment_integration
end
