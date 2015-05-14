require 'sinatra/activerecord'
require 'protected_attributes'
require 'rbnacl/libsodium'
require 'base64'

# user entity
class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :hashed_password, presence: true
  validates :password_salt, presence: true
  validates :email, presence: true, format: /@/
  validates :fullname, presence: true
  validates :address, presence: true
  validates :dob, presence: true

  # ignore these fields when doing mass assignment
  attr_protected :hashed_password, :password_salt,
                 :fullname_nonce, :address_nonce, :dob_nonce

  # static methods
  def self.authenticate!(username, password)
    user = User.find_by_username(username)
    user && user.password_matches?(password) ? user : nil
  end

  def self.hash_password(salt, password)
    # (password, salt, max operations, max memory, digest size)
    RbNaCl::PasswordHash.scrypt(password, salt, 2**20, 2**24, 64)
  end

  # setter for password
  def password=(password)
    salt = RbNaCl::Random.random_bytes(RbNaCl::PasswordHash::SCrypt::SALTBYTES)
    password_digest = self.class.hash_password(salt, password)
    self.password_salt = Base64.urlsafe_encode64(salt)
    self.hashed_password = Base64.urlsafe_encode64(password_digest)
  end

  def password_matches?(password)
    input_password = self.class.hash_password(
      Base64.urlsafe_decode64(password_salt),
      password
    )
    Base64.urlsafe_encode64(input_password) == hashed_password
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
