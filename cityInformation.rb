require_relative 'models/city'
class CityInformation
	attr_accessor :city
	def initialize(city)
		@city = city
	end
	def getInfo
		raise ArgumentError unless city.country
		city.locate
		"#{@city.name}: #{@city.latitude},#{@city.longitude}"
	end
	def weatherInfo
		city.todays_weather
		"It is #{@city.weather_today.temperature_celsius} C and #{@city.weather_today.condition}"
	end
end


berlin = City.new("Berlin")
berlin.country = "Germany"
berlinInfo = CityInformation.new(berlin)
p berlinInfo.getInfo
p berlinInfo.weatherInfo