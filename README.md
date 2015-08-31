Using an API 
============

#Challenge
* We want to convert a latitude and longitude into a street address

#Selecting an API
* Google it!
* Find a possible API
* Scan the docs to see if it does what we need [https://developers.google.com/maps/documentation/geocoding/](https://developers.google.com/maps/documentation/geocoding/)
* Check that we can access it in a way we know how
  * Raw HTTP / JSON  
  * Maybe there is a gem?

* Looks like we can use json over http/https:

```
https://maps.googleapis.com/maps/api/geocode/json?parameters
```

#Get an API Key
* [https://developers.google.com/maps/documentation/geocoding/#api_key](https://developers.google.com/maps/documentation/geocoding/#api_key)
* Create an app and give it a name
* And enable the Geocoding API (lot of other available too)

#Get a Gem to do Server Side requests
* [https://github.com/jnunemaker/httparty](https://github.com/jnunemaker/httparty)
* [https://github.com/typhoeus/typhoeus](https://github.com/typhoeus/typhoeus)

#Write a simple app to test it out

```
require 'dotenv'
require 'httparty'
require 'json'

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

class GeoCodeClient
  include HTTParty
  base_uri 'https://mapds.googleapis.com/maps/api/geocode/json'

  def convert_address_to_lat_long(address)
    response = self.class.get('',
                              query: {
                                key: ENV['GOOGLE_API_KEY'],
                                address: address
                              })
    if response.success?
      json = JSON.parse(response.body)
      json['results'].first['geometry']['location']
    else
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
```




