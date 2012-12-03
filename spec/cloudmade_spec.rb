require 'spec_helper'

describe Cloudmade do
	subject { Cloudmade.new("5417a6b95e8544b7a8814ac874ebd27b")}
	its(:api_key) { should_not be_nil }
	its(:api_url) { should_not be_nil}
	
	it 'builds the API query'
	it 'connects to the service'
	it 'returns a 200 header'
	it 'gets a json string'
	it 'parses the json'
	it 'returns the lat, long'
end