class User < ActiveRecord::Base
  has_secure_password
  has_many :solutions
  has_many :problems
  
  validates :username, presence: true, uniqueness: true
end
