require 'json'
require 'sinatra'
require_relative 'model/credit_card.rb'
require_relative 'model/user.rb'
require_relative 'helpers/credit_card_api_helper.rb'

# credit card api service
class CreditCardAPI < Sinatra::Base
  include CreditCardAPIHelper

  # TODO: add necessary configurations
  # => sessions & cookies
  # => logging

  before do
    # TODO: assign proper user to @current_user
    @current_user
  end

  get '/' do
    haml :index
  end

  get '/api/v1/users/sign_up/?' do
    haml :sign_up
  end

  post '/api/v1/users/sign_up/?' do
    # TODO: fill in sign up logics
  end

  get '/api/v1/users/sign_in/?' do
    haml :sign_in
  end

  post '/api/v1/users/sign_in/?' do
    # TODO: fill in sign in logics
  end

  post '/api/v1/users/sign_out/?' do
    # TODO: fill in sign out logics
    # => make sure it redirects to sign in page
  end

  get '/api/v1/credit_card/validate/?' do
    number = params[:card_number]
    halt 400 unless number
    card = CreditCard.new
    card.number = number
    {
      card: number,
      validated: card.validate_checksum
    }.to_json
  end

  post '/api/v1/credit_card/?' do
    request_json = request.body.read
    unless request_json.empty?
      begin
        obj = JSON.parse(request_json)
        card = CreditCard.new(
          expiration_date: obj['expiration_date'],
          owner: obj['owner'],
          credit_network: obj['credit_network']
        )
        card.number = obj['number'].chomp
        if card.validate_checksum && card.save
          status 201
          body({
            status: 201,
            message: 'Created'
          }.to_json)
        else
          status 410
          body({
            status: 410,
            message: 'Gone'
          }.to_json)
        end
      rescue
        halt 400, {
          status: 400,
          message: 'Bad Request'
        }.to_json
      end
    end
  end

  get '/api/v1/credit_card/all/?' do
    begin
      CreditCard.all.map(&:to_hash).to_json
    rescue
      halt 500
    end
  end
end
