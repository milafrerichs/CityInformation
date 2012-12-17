class City
	attr_accessor :name, :country, :latitude, :longitude, :locator
	
	def initialize(name)
		@name = name
	end
	def locate
		loc = locator.locate(@name)
		@latitude = loc.latitude
		@longitude = loc.longitude
	end
end