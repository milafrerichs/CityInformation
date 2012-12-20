require 'net/http'
require 'json'
require 'addressable/uri'

class CityAPI
	attr_reader :api_key,:api_url,:request_url, :response
	
	def initialize(api_key)
		@api_key = api_key
		@api_url = ""
		@request_url = Addressable::URI.parse @api_url
	end
	
	def buildQuery(request_string)
		@request_url = Addressable::URI.escape("#{@api_url}#{request_string}",Addressable::URI)
		self
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
end