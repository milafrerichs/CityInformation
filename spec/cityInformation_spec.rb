require 'spec_helper'

describe CityInformation do 
	subject {CityInformation.new("Berlin")}
	its(:city) { should == "Berlin" }
	its(:latitude) { should be_nil}
	its(:longitude) { should be_nil}
	context 'Location' do
		
		describe 'connect to cloudmade API' do
			let(:cloudmade) { Cloudmade.new("5417a6b95e8544b7a8814ac874ebd27b")}
			it 'has an API Key' do
				cloudmade.api_key.should_not be_nil
			end
			it 'returns an json string' do
				#expect { mapbox.locate}.to 
			end
		end
		
		describe 'retrieve location' do
			it 'has a longitude' do
				expect { subject.locate}.to change {subject.longitude}.to be_kind_of(Float)
			end
			it 'has a latitude' do
				expect { subject.locate}.to change {subject.latitude}.to be_kind_of(Float)
			end
		end
	end
	
	context 'weather' do
		describe 'connect to yahoo weater' do
			let(:yahoo) { Yahoo.new }
			describe 'receive weather information' do
				context 'today' do
					it 'has a temparutere' do
						pending
					end
					it 'has a ' do
						pending
					end
				end
				context 'forecast' do
					it 'has a temparutere' do
						pending
					end
					it 'has a ' do
						pending
					end
				end
				
			end
		end
	end
end