require 'json'
require 'openssl'
require 'sinatra/activerecord'
require 'rbnacl/libsodium'
require_relative '../environments.rb'
require_relative '../lib/luhn_validator.rb'

# Credit card entity
class CreditCard < ActiveRecord::Base
  # Mixin the validator
  include LuhnValidator

  @@secret_box ||= RbNaCl::SecretBox.new([ENV['DB_KEY']].pack('H*'))

  # instance variables with automatic getter/setter methods
  # attr_accessor :number, :expiration_date, :owner, :credit_network
  #
  # def initialize(number, expiration_date, owner, credit_network)
  #   @number = number
  #   @expiration_date = expiration_date
  #   @owner = owner
  #   @credit_network = credit_network
  # end

  # returns json string
  def to_json
    {
      number: number,
      expiration_date: @expiration_date,
      owner: @owner,
      credit_network: @credit_network
    }.to_json
  end

  # returns all card information as single string
  def to_s
    to_json
  end

  # return a new CreditCard object given a serialized (JSON) representation
  def self.from_s(card_s)
    card = JSON.parse(card_s)
    CreditCard.new(card['number'], card['expiration_date'],
                   card['owner'], card['credit_network'])
  end

  # return a hash of the serialized credit card object
  def hash
    to_json.hash
  end

  # return a cryptographically secure hash
  def hash_secure
    OpenSSL::Digest::SHA256.new.digest(to_json).unpack('H*').first
  end

  # number getter
  def number
    @@secret_box.decrypt [nonce].pack('H*'), [encrypted_number].pack('H*')
  end

  # number setter
  def number=(plain)
    nonce = RbNaCl::Random.random_bytes(@@secret_box.nonce_bytes)
    self.nonce = nonce.unpack('H*').first
    self.encrypted_number = @@secret_box.encrypt(nonce, plain)
                                        .unpack('H*').first
  end
end
