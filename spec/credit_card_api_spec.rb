require 'json'

require_relative 'rack_test_helper.rb'
require_relative '../app.rb'

include Rack::Test::Methods

def app
  CreditCardAPI
end


describe 'Root route' do
  it 'should return a message that the service is available' do
    get '/'
    # must be 2xx or 3xx
    assert_includes(200..399, last_response.status)
    # body can't be empty
    refute_empty(last_response.body)
  end
end

describe 'Validation route' do
  it 'should return a JSON containing card numbers and validation state' do
    cards = [
      {
        number: '4024097178888052',
        valid: false
      },
      {
        number: '4916603231464963',
        valid: true
      }
    ]
    cards.each do |card|
      get '/api/v1/credit_card/validate', card_number: card[:number]
      # must be 2xx or 3xx
      assert_includes(200..399, last_response.status)
      # body should be correct in format
      resp = JSON.parse last_response.body
      assert_equal(resp['card'], card[:number])
      assert_equal(resp['validated'], card[:valid])
    end
  end
end
