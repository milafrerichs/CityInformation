require_relative 'cityapi'

class Flickr < CityAPI
	attr_accessor :photos
	def initialize(api_key)
		super
		@api_url = "http://api.flickr.com/services/rest/"
		@photos = Array.new
	end
	
	def get_flickr_place_id(city)
		query_string = "?method=flickr.places.findByLatLon&api_key=#{@api_key}&lat=#{city.latitude}&lon=#{city.longitude}&format=json&nojsoncallback=1"
		buildQuery(query_string)
		@response = parseResponse
		if @response["stat"] == "ok"
			@response["places"]["place"][0]["place_id"] unless @response["places"]["total"] < 1
		end
	end
	
	def photos_for_place_id(place_id)
		
		query_string = "?method=flickr.photos.search&api_key=#{@api_key}&place_id=#{place_id}&format=json&nojsoncallback=1"
		buildQuery(query_string)
		@response = parseResponse
		if @response["stat"] == "ok"
			flickr_photos = @response["photos"]["photo"]
			flickr_photos.each do |photo|
				@photos << "http://farm#{photo["farm"]}.staticflickr.com/#{photo["server"]}/#{photo["id"]}_#{photo["secret"]}_q.jpg"
			end
		end
	end
end