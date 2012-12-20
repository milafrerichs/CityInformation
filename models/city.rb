require_relative 'cloudmade'
require_relative 'weather'
require_relative 'wunderground'

class City
	attr_accessor :name, :country, :latitude, :longitude, :locator, :weatherman, :weather_today, :weather_forecast
	
	def initialize(name)
		@name = name
		@locator = Cloudmade.new("5417a6b95e8544b7a8814ac874ebd27b")
		@weatherman = Wunderground.new("b382e4b2e8ddc86b")
		@weather_today = Weather.new
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
end