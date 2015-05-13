require 'sinatra/activerecord'
require 'protected_attributes'
require 'rbnacl/libsodium'
require 'base64'

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
  attr_protected :hashed_password, :password_salt,
                 :fullname_nonce, :address_nonce, :dob_nonce

  # static methods
  def self.authenticate!(username, password)
    # TODO: authenticate user
  end

  def self.hash_password(salt, password)
    # TODO: hash password
  end

  # setter for password
  def password=(password)
    # TODO: fill in set password logic
  end

  def password_matches?(password)
    # TODO: check if password matches
  end

  # setters
  def fullname=(name)
    encrypt_field(:fullname, name)
  end

  def address=(addr)
    encrypt_field(:address, addr)
  end

  def dob=(birthday)
    encrypt_field(:dob, birthday)
  end

  # getters
  def fullname
    decrypt_field(:fullname)
  end

  def address
    decrypt_field(:address)
  end

  def dob
    decrypt_field(:dob)
  end

  private

  def secret_box
    @secret_box ||= RbNaCl::SecretBox.new(Base64.urlsafe_decode64(ENV['DB_KEY']))
  end

  def encrypt_field(field_name, value)
    nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
    enc_val = Base64.urlsafe_encode64(secret_box.encrypt(nonce, value))
    send("#{field_name}_nonce=", Base64.urlsafe_encode64(nonce))
    write_attribute(field_name, enc_val)
  end

  def decrypt_field(field_name)
    enc_val = Base64.urlsafe_decode64(read_attribute(field_name))
    nonce = Base64.urlsafe_decode64(send("#{field_name}_nonce"))
    secret_box.decrypt(nonce, enc_val)
  end
end
