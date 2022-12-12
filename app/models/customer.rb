class Customer < ApplicationRecord
  has_many :licenses
  belongs_to :client
end
