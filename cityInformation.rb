require 'rspec'
require 'net/http'
require 'json'

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
	def connect
		uri = URI(@api_url)
		response = Net::HTTP.get_response(uri)
		
		case response
		when Net::HTTPSuccess
		  response.body
		else
		  response.error!
		end
		
	end
	def parseResponse(response)
		repo_info = JSON.parse response
	end
	def findCity(cityname)
		params = {"query"=>cityname}
		buildQuery(params).connect
	end
	def buildQuery(params)
		url_params = URI.escape(params.collect{|k,v| "#{k}=#{v}"}.join('&'))
		@api_url = "#{@api_url}?#{url_params}"
		self
	end
end


