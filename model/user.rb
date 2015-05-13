# user entity
class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :hashed_password, presence: true
  validates :password_salt, presence: true
  # TODO: validate email format
  validates :email, presence: true
  validates :fullname, presence: true
  validates :address, presence: true
  # TODO: validates date format
  validates :dob, presence: true

  # ignore these fields when doing mass assignment
  attr_protected :hashed_password, :password_salt

  
end
