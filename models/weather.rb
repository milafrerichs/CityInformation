class Weather
	attr_accessor :temperature, :condition, :condition_icon, :high_low_temperature
	
	def temperature_celsius
		temperature[:C]
	end
end