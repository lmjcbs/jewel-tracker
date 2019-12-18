class User < ActiveRecord::Base

  has_many :jewels
  
  validates :username, uniqueness: true, length: { in: 3..12 }
  validates :password, length: { minimum: 6 }
  has_secure_password

end