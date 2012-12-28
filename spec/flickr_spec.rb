require 'spec_helper'

describe Flickr do
	subject { Flickr.new("d397b74cc2c8c86d4a042ffe10099ed3") }
	its(:api_url) { should_not be_nil}
	its(:request_url) { should_not be_nil}
	its(:response) { should be_nil}
	
	
	context 'flickr api' do
		describe '#flickr_place_id_for_lat_lng' do
			let(:latitude) { 13.38885 }
			let(:longitude) { 52.51704 }
			let(:response) { { "places" => { "place" => [ { "place_id" => "zUUW42ZTUb7y5HPznQ"}], "accuracy" => 16, "total" => 1 }, "stat" => "ok" } }
			before {
				subject.stub(:parseResponse).and_return(response)
			}
			it 'has latitutde and longitude' do
				subject.should_receive(:flickr_place_id_for_lat_lng).with(latitude,longitude)
				subject.flickr_place_id_for_lat_lng(latitude,longitude)
			end
			it 'builds the query' do
				subject.should_receive(:buildQuery).with("?method=flickr.places.findByLatLon&api_key=d397b74cc2c8c86d4a042ffe10099ed3&format=json&nojsoncallback=1&lat=13.38885&lon=52.51704")
				subject.flickr_place_id_for_lat_lng(latitude,longitude)
			end
			context 'returns flickr place id' do
				it 'parses the result' do
					subject.should_receive(:parseResponse)
					subject.flickr_place_id_for_lat_lng(latitude,longitude)
				end
				it 'has a status ok' do
					
					expect(subject.flickr_place_id_for_lat_lng(latitude,longitude)).to eq "zUUW42ZTUb7y5HPznQ"
				end
			end
			context 'returns an error' do
				it 'has a non ok status' do
					
				end
				it 'has a count less than one' do
					
				end
			end
		end	
		
		describe '#photos_for_place_id' do
			let(:place_id) { "zUUW42ZTUb7y5HPznQ" }
			let(:response) { { "photos" => { "page" => 1, "pages" => "190", "perpage" => 100, "total" => "18981", "photo" => [ { "id" => "8298865459", "owner" => "40183578@N08", "secret" => "1d0b8bba27", "server" => "8358", "farm" => 9, "title" => "Morning", "ispublic" => 1, "isfriend" => 0, "isfamily" => 0 }, { "id" => "8297857220", "owner" => "33647201@N08", "secret" => "7af1406751", "server" => "8083", "farm" => 9, "title" => "Smile !", "ispublic" => 1, "isfriend" => 0, "isfamily" => 0 }, ] }, "stat" => "ok" } }
			before {
				subject.stub(:parseResponse).and_return(response)
			}
			it 'has a place_id' do
				subject.should_receive(:photos_for_place_id).with(place_id)
				subject.photos_for_place_id(place_id)
			end
			it 'builds the query' do
				subject.should_receive(:buildQuery).with("?method=flickr.photos.search&api_key=d397b74cc2c8c86d4a042ffe10099ed3&format=json&nojsoncallback=1&place_id=zUUW42ZTUb7y5HPznQ")
				subject.photos_for_place_id(place_id)
			end
			it 'returns photos' do
				expect { subject.photos_for_place_id(place_id) }.to change { subject.photos.count }.by(2)
			end
		end
	end
end