require 'json'
require 'sinatra'
require './model/credit_card.rb'
require_relative 'model/operation.rb'
#require_relative 'lib/credit_card.rb'

# credit card api service
class CreditCardAPI < Sinatra::Base
  get '/' do
    'Credit Card Application is up and running: API available at /api/v1/'
  end

  get '/api/v1/credit_card/validate' do
    number = params[:card_number]
    halt 400 unless number
    card = CreditCard.new(number, nil, nil, nil)
    {
      card: number,
      validated: card.validate_checksum
    }.to_json
  end

  post '/api/v1/credit_card' do
    number = nil
    expiration_date = nil
    owner = nil
    credit_network = nil
    request_json = request.body.read
    begin
      unless request_json.empty?
        req = JSON.parse(request_json)
        number = req['number']
        expiration_date = req['expiration_date']
        owner = req['owner']
        credit_network = req['credit_network']
      end
      card = CreditCard.new(number, nil, nil, nil)
    rescue
      halt 400
    end
  end

  get '/api/v1/all_credit_cards' do

  end

end
