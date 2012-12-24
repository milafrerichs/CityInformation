require_relative 'cityapi'

class Flickr < CityAPI
	attr_reader :photos
	def initialize(api_key)
		super
		@api_url = "http://api.flickr.com/services/rest/"
		@photos = Array.new
	end
	
	def flickr_query(method)
		"?method=#{method}&api_key=#{@api_key}&format=json&nojsoncallback=1"
	end
	
	def query_successfull?
		case @response["stat"]
			when "ok" 
				true
			else 
				false
		end
	end
	
	def call_api(query)
		buildQuery(query)
		@response = parseResponse
		
	end
	def flickr_place_id_for_lat_lng(latitude,longitude)
		call_api("#{flickr_query("flickr.places.findByLatLon")}&lat=#{latitude}&lon=#{longitude}")
		if query_successfull?
			@response["places"]["place"][0]["place_id"] unless @response["places"]["total"] < 1
		end
	end
	
	def photos_for_place_id(place_id)
		
		call_api("#{flickr_query("flickr.photos.search")}&place_id=#{place_id}")
		if query_successfull?
			flickr_photos = @response["photos"]["photo"]
			flickr_photos.each do |photo|
				@photos << "http://farm#{photo["farm"]}.staticflickr.com/#{photo["server"]}/#{photo["id"]}_#{photo["secret"]}_q.jpg"
			end
		end
	end
end