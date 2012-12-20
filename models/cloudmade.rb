require 'net/http'
require 'json'
require 'addressable/uri'

class Cloudmade
	attr_reader :api_key, :api_url, :request_url,:city,:response
	def initialize(api_key)
		@api_key = api_key
		@api_url = "http://geocoding.cloudmade.com/#{@api_key}/geocoding/v2/find.js"
		@request_url = Addressable::URI.parse @api_url
		@city = ""
		@response = ""
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
	
	def connect
		response = Net::HTTP.get_response(@request_url)
		
		case response
		when Net::HTTPSuccess
		  response.body
		else
		  response.error!
		end
		
	end
	def parseResponse
		
			JSON.parse connect
		
	end
	
	def buildQuery(request_string)
		@request_url = Addressable::URI.escape("#{@api_url}#{request_string}",Addressable::URI)
		self
	end
end