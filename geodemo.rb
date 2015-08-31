require 'dotenv'
require 'httparty'
require 'json'

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  puts 'Skipping Dotenv - remember to set environment variables directly'
end

class GeoCodeClient
  include HTTParty
  base_uri 'https://maps.googleapis.com/maps/api/geocode'

  def convert_address_to_lat_long(address)
    response = self.class.get('/json', query: {
                                key: ENV['GOOGLE_API_KEY'],
                                address: address,
                                language: 'ar'
                              })
    if response.success?
      json = JSON.parse(response.body)
      json['results'].first['geometry']['location']
    else
      p response
      nil
    end
  end
end

client = GeoCodeClient.new

example_address = '655 Mission St, San Francisco, CA 94105'

lat_long = client.convert_address_to_lat_long(example_address)

if lat_long
  puts "(#{lat_long['lat']},#{lat_long['lng']}) -> #{example_address}"
else
  puts "Unable to decode -> #{example_address}"
end
