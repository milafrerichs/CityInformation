class Weather
	attr_accessor :temperature, :condition, :condition_icon, :high_low_temperature
	
	def initialize
		@temperature = {C:0.0,F:0.0}
	end
	
	def to_s
		"#{@condition} and #{temperature_celsius} C"
	end
	
	def temperature_celsius
		temperature[:C]
	end
end