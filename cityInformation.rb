require 'rspec'
class CityInformation
	attr_accessor :city, :latitude, :longitude
	def initialize(cityname)
		@city = cityname
	end
	
	def locate
		response = {"latitude"=>"7.9432","longitude"=>"51.8639"}
		@latitude = response["latitude"].to_f
		@longitude = response["longitude"].to_f
	end
end


class Cloudmade
	attr_reader :api_key, :api_url
	def initialize(api_key)
		@api_key = api_key
		@api_url = "http://geocoding.cloudmade.com/#{@api_key}/geocoding/v2/find.js"
	end
	
	def find(query)
		params = {"query"=> query}
		
	end
end


