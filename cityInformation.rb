require_relative 'models/city'
class CityInformation
	attr_accessor :city
	def initialize(city)
		@city = city
	end
	
	def getInfo
		raise ArgumentError unless city.country
		@city.locate
		"#{@city}"
	end
	
	def weatherInfo
		@city.todays_weather
		"It is #{@city.weather_today}"
	end
	
	def photos
		@city.cityphotos
		@city.photos.each do |photo|
			"#{photo}"
		end
	end
end


berlin = City.new("Berlin")
berlin.country = "Germany"
berlinInfo = CityInformation.new(berlin)
p berlinInfo.getInfo
p berlinInfo.weatherInfo
p berlinInfo.photos