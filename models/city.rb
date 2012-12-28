require_relative 'cloudmade'
require_relative 'weather'
require_relative 'wunderground'
require_relative 'flickr'

class City
	attr_accessor :name, :country, :latitude, :longitude, :locator, :weatherman, :photographer, :weather_today, :weather_forecast, :photos
	
	def initialize(name)
		@name = name
		@locator = Cloudmade.new("5417a6b95e8544b7a8814ac874ebd27b")
		@weatherman = Wunderground.new("b382e4b2e8ddc86b")
		@weather_today = Weather.new
		@photographer = Flickr.new("d397b74cc2c8c86d4a042ffe10099ed3")
		@photos = Array.new
	end
	
	def to_s
		"#{@name} (#{@latitude}, #{@longitude})"
	end
	
	def locate
		loc = locator.locate(@name)
		@latitude = loc[:latitude]
		@longitude = loc[:longitude]
	end
	
	def todays_weather
		locate unless @latitude != nil
		@weatherman.weatherInfoForLatlng(@latitude,@longitude,"conditions")
		@weather_today.temperature = @weatherman.temperature
		@weather_today.condition = @weatherman.condition
		@weather_today.condition_icon = @weatherman.icon_url
	end
	
	def weather_forecast
		
	end
	
	def cityphotos
		place_id = @photographer.flickr_place_id_for_lat_lng(@latitude,@longitude)
		@photos = @photographer.photos_for_place_id(place_id)
	end
	
end