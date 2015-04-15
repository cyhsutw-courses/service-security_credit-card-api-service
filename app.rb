require 'json'
require 'sinatra'

require_relative 'lib/credit_card.rb'

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
end
