require_relative 'cityapi'

class Cloudmade < CityAPI
	attr_accessor :city
	
	def initialize(api_key)
		super
		@api_url = "http://geocoding.cloudmade.com/#{@api_key}/geocoding/v2/find.js"
		@city = ""
		
	end
	def locate(city)
		@city = city
		searchForCity
		getLatLng
		
	end
	def searchForCity
		request_string = "?query=#{@city}"
		buildQuery(request_string)
	end
	def getLatLng
		json_response = parseResponse
		if json_response.has_key? "found" 
			if json_response["found"] > 0
				latitude = json_response["features"][0]["centroid"]["coordinates"][0].to_f
				longitude = json_response["features"][0]["centroid"]["coordinates"][1].to_f
				{latitude:latitude,longitude:longitude}
			end
		else
			raise RangeError, "Error Message" 
		end
	end
end