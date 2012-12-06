require 'spec_helper'

describe Cloudmade do
	subject { Cloudmade.new("5417a6b95e8544b7a8814ac874ebd27b")}
	its(:api_key) { should_not be_nil }
	its(:api_url) { should_not be_nil}
	
	it 'builds the API query to match the city name' do
		params = {"query"=>"Berlin"}
		expect { subject.buildQuery(params)}.to change{subject.api_url}
		
	end
	it 'can connect to the service' do
		subject.should respond_to(:connect)
	end
	
	context "conecting" do
		let(:cloudmade) { Cloudmade.new("okokko") }
		before {
			params = {"query"=>"Berlin"}
			subject.buildQuery(params)
		}
		it 'raises an error if api key is wrong empty' do
			expect { cloudmade.connect}.to raise_error(Net::HTTPServerException)
		end
		it 'gets a non empty string' do
			subject.connect.should_not == ""
		end
		
	end
	context 'parses the json' do
		it 'returns valid json' do
			response = subject.connect
			expect { subject.parseResponse(response)}.to_not raise_error(JSON::ParserError)
		end
		it 'raises an error if response is no json' do
			response = "hj"
			expect { subject.parseResponse(response)}.to raise_error(JSON::ParserError)
		end
	end
	it 'returns the lat, long'
end