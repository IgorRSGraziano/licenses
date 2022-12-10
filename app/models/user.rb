class User < ApplicationRecord
  has_secure_password
  has_many :licenses
  belongs_to :client
end
