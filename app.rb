require 'json'
require 'sinatra'
require './model/credit_card.rb'

# credit card api service
class CreditCardAPI < Sinatra::Base
  get '/' do
    'Credit Card Application is up and running: API available at /api/v1/'
  end

  get '/api/v1/credit_card/validate' do
    number = params[:card_number]
    halt 400 unless number
    card = CreditCard.new
    card.number = number
    {
      card: number,
      validated: card.validate_checksum
    }.to_json
  end

  post '/api/v1/credit_card' do
    request_json = request.body.read
    unless request_json.empty?
      begin
        obj = JSON.parse(request_json)
        card = CreditCard.new(
          expiration_date: obj['expiration_date'],
          owner: obj['owner'],
          credit_network: obj['credit_network']
        )
        card.number = obj['number']
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

  get '/api/v1/credit_card/all' do
    begin
      CreditCard.all.to_json
    rescue
      halt 500
    end
  end

end
