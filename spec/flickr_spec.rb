require 'spec_helper'

describe Flickr do
	subject { Flickr.new("d397b74cc2c8c86d4a042ffe10099ed3") }
	its(:api_url) { should_not be_nil}
	its(:request_url) { should_not be_nil}
	its(:response) { should be_nil}
	
	
	context 'flickr api' do
		describe '#get_flickr_place_id' do
			let(:city) { stub(latitude: 13.38885, longitude: 52.51704) }
			let(:response) { { "places" => { "place" => [ { "place_id" => "zUUW42ZTUb7y5HPznQ"}], "accuracy" => 16, "total" => 1 }, "stat" => "ok" } }
			before {
				subject.stub(:parseResponse).and_return(response)
			}
			it 'has latitutde and longitude' do
				subject.should_receive(:get_flickr_place_id).with(city)
				subject.get_flickr_place_id(city)
			end
			it 'builds the query' do
				subject.should_receive(:buildQuery).with("?method=flickr.places.findByLatLon&api_key=d397b74cc2c8c86d4a042ffe10099ed3&lat=13.38885&lon=52.51704&format=json&nojsoncallback=1")
				subject.get_flickr_place_id(city)
			end
			context 'returns flickr place id' do
				it 'parses the result' do
					subject.should_receive(:parseResponse)
					subject.get_flickr_place_id(city)
				end
				it 'has a status ok' do
					
					expect(subject.get_flickr_place_id(city)).to eq "zUUW42ZTUb7y5HPznQ"
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
				subject.should_receive(:buildQuery).with("?method=flickr.photos.search&api_key=d397b74cc2c8c86d4a042ffe10099ed3&place_id=zUUW42ZTUb7y5HPznQ&format=json&nojsoncallback=1")
				subject.photos_for_place_id(place_id)
			end
			it 'returns photos' do
				expect { subject.photos_for_place_id(place_id) }.to change { subject.photos.count }.by(2)
			end
		end
	end
end