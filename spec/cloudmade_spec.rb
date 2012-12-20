require 'spec_helper'

describe Cloudmade do
	subject { Cloudmade.new("5417a6b95e8544b7a8814ac874ebd27b")}
	its(:api_key) { should_not be_nil }
	its(:api_url) { should_not be_nil}
	its(:request_url) { should_not be_nil}
	its(:city) { should_not be_nil}
	its(:response) { should be_nil}
	
	it 'builds the API query to match the city name' do
		expect { subject.buildQuery("?query=Berlin")}.to change{subject.request_url}
	end
	it 'can connect to the service' do
		subject.should respond_to(:connect)
	end
	
	context "conecting with wrong API Key" , online: true do
		let(:cloudmade) { Cloudmade.new("okokko") }
		
		it 'raises an error ' do
			subject.stub(:buildQuery).with("?query=Berlin") { :return_value }
			pending
			#expect { cloudmade.connect}.to raise_error(Net::HTTPServerException)
		end
	end
	context 'parses the json' do
		context 'is valid json' do
			let(:response) { '{"found":1,"bounds":[[],[]],"features":[{"id":1234}]}'}
			it 'returns valid json' do
				subject.stub(:connect).and_return(response)
				subject.stub(:parseResponse) { :return_value }
				expect { subject.parseResponse}.to_not raise_error(JSON::ParserError)
			end
		end
		context 'is invalid json' do
			it 'raises an error ' do
				response = "hj"
				subject.stub(:connect).and_return(response)
				expect { subject.parseResponse}.to raise_error(JSON::ParserError)
			end
		end
	end
	context '#locate' do
		let(:location) { {:latitude=>13.38885,:longitude=>52.51704} }
		it 'searchs for the city' do
			subject.should_receive(:searchForCity)
			subject.stub(:getLatLng).and_return(location)
			subject.locate("Berlin")
		end
		it 'builds the cloudmade query' do
			subject.should_receive(:buildQuery).and_return(subject)
			subject.stub(:connect)
			subject.stub(:getLatLng).and_return(location)
			subject.locate("Berlin")
		end
		
		it 'connects to cloudmade' do
			subject.should_receive(:connect).and_return("{}")

			subject.parseResponse
		end
		
		context 'has no results' do
			it 'returns error' do
				response = '{}'
				subject.stub(:connect).and_return(response)
				expect { subject.locate("")}.to raise_error(RangeError)
			end
		end
		it 'returns valid lat, long' do
			response = '{"found": 1, "bounds": [[52.37982, 13.16428], [52.65383, 13.61343]], "features": [{"id": 6624612,"centroid": {"type":"POINT","coordinates":[52.51704, 13.38885]},"bounds": [[52.37982, 13.16428], [52.65383, 13.61343]],"properties": {},"type": "Feature"}], "type": "FeatureCollection", "crs": {"type": "EPSG", "properties": {"code": 4326, "coordinate_order": [0, 1]}}}'
			json_obj = {"found"=>1,"features"=>[{"id"=>"1234","centroid"=>{"coordinates"=>[13.38885,52.51704]}}]}
			subject.stub(:connect).and_return(response)
			subject.stub(:parseResponse).and_return(json_obj)
			expect(subject.locate("Berlin")).to eq location
		end
	end
end