require 'json'
require 'sinatra'

require_relative 'lib/credit_card.rb'

class CreditCardAPI < Sinatra::Base
  # TODO: add API paths

  get '/' do
    'Credit Card app is up and running, API available at /api/v1/'
  end

  get '/api/v1/' do
    'Services offered include <br>'\
    'GET /api/v1/credit_card/validate?number=[your credit card number]<br>' \
    'POST /api/v1/validate_checksum(numeric parameters: max, body)'
  end

  get '/api/v1/credit_card/validate' do
    number = params[:number]
    halt 400 unless number

    { hash: number.hash,
    notes: 'Non-cryptographic hash,not for secure use'
    }.to_json
  end



end
