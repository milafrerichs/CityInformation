require 'net/http'
require 'json'
require 'addressable/uri'

class Wunderground
	attr_reader :api_key,:api_url,:request_url, :response
	
	def initialize(api_key)
		@api_key = api_key
		@api_url = "http://api.wunderground.com/api/#{@api_key}/"
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
	
	def weatherInfoForLatlng(latitude,longitude,feature)
		buildQuery("#{feature}/geolookup/q/#{latitude},#{longitude}.json")
		@response = parseResponse
	end
	
	def temperature
		temp_f = @response['current_observation']['temp_f'].to_f
		temp_c = @response['current_observation']['temp_c'].to_f
		
		{F: temp_f,C: temp_c}
	end
	
	def condition
		@response['current_observation']['weather']
	end
	
	def icon_url
		@response['current_observation']['icon_url']
	end
	
	def high_lows
		high_lows = Array.new
		cycle_forecasts do |forecast|
			temp_high_f = forecast["high"]["fahrenheit"].to_f
			temp_high_c = forecast["high"]["celsius"].to_f
			temp_low_f = forecast["low"]["fahrenheit"].to_f
			temp_low_c = forecast["low"]["celsius"].to_f
			high_lows << { high: { C: temp_high_c, F: temp_high_f }, low: { C: temp_low_c, F:temp_low_f } }
		end
		
		high_lows
	end
	
	def conditions
		conditions = Array.new
		cycle_forecasts do |forecast|
			conditions << {:txt=>forecast["conditions"],:icon=>forecast["icon_url"]}
		end
		
		conditions
	end
	
	def cycle_forecasts(&block)
		forecasts = @response['simpleforecast']['forecastday']
		forecasts.each(&block)
	end
end

##radar
#/radar/image.gif?centerlat=38&centerlon=-96.4&radius=100&width=280&height=280&newmaps=1