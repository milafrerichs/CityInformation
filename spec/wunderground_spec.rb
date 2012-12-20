require 'spec_helper'
describe Wunderground do
		describe 'connect to wunderground weather' do
			subject { Wunderground.new("b382e4b2e8ddc86b") }
			its(:api_key) { should_not be_nil }
			its(:api_url) { should_not be_nil}
			its(:request_url) { should_not be_nil}
			its(:response) { should be_nil}
			let(:query) { "/conditions/geolookup/q/Germany/Berlin.json" }
			context 'connect to API' do
				
				it 'builds the API query' do
					subject.should respond_to(:buildQuery)
					expect { subject.buildQuery(query)}.to change{subject.request_url}
				end
				it 'can connect to the service' do
					subject.should respond_to(:connect)
				end
			end
			context "conecting with wrong API Key" , online: true do
				let(:wunderground) { Wunderground.new("okokko") }
		
				it 'raises an error ' do
					subject.stub(:buildQuery).with(query) { :return_value }
					#expect { wunderground.connect}.to raise_error(Net::HTTPServerException)
				end
			end
			context 'parses the json' do
				
				context 'is valid json' do
					let(:response) { '{"test":1}'}
					it 'returns valid json' do
						subject.stub(:connect).and_return(response)
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
				
				context 'connection failed' do
					it 'raises an error' do
						#subject.stub(:connect).and_return(Net::HTTPError)
						#expect { subject.parseResponse}.to raise_error(Net::HTTPError)
					end
				end
				
			end
			describe 'receive weather information', online:true do
				let(:city) { stub(latitude:52.51704 , longitude:13.38885)}
				context 'for a lat lng location' do
					context '#weatherInfoForLatlng' do
						it 'builds the query with lat lng' do
							subject.should_receive(:buildQuery).with("forecast/geolookup/q/52.51704,13.38885.json")
							subject.stub(:parseResponse).and_return("")
							subject.weatherInfoForLatlng(52.51704,13.38885,"forecast")
						end
						it 'connects to the api' do
							pending #maybe stub the http with webmock
						end
						it 'parses the json' do
							subject.stub(:connect).and_return("{}")
							subject.should_receive(:parseResponse).and_return({})
							subject.weatherInfoForLatlng(52.51704,13.38885,"forecast")
						end
						it 'saves the response' do
							subject.stub(:connect).and_return("{}")
							subject.should_receive(:parseResponse).and_return({})
							expect { subject.weatherInfoForLatlng(52.51704,13.38885,"forecast") }.to change {subject.response}
						end
					end
				end
				context 'today' do
					before {
						subject.stub(:parseResponse).and_return({"current_observation"=>{"temp_f"=>"76","temp_c"=>"12","weather"=>"Mostly cloudy","icon_url"=>"http://icons-ak.wxug.com/i/c/k/mostlycloudy.gif"}})
						subject.weatherInfoForLatlng(52.51704,13.38885,"conditions")
					}
					it 'has a temperature' do
						temp = {:C=>12,:F=>76}
						expect(subject.temperature).to eq temp
					end
					it 'has a condition' do
						condition = "Mostly cloudy"
						expect(subject.condition).to eq condition
					end
					it 'has a condition icon' do
						iconUrl = "http://icons-ak.wxug.com/i/c/k/mostlycloudy.gif"
						expect(subject.icon_url).to eq iconUrl
					end
				end
				context 'forecast' do
					before {
						subject.stub(:parseResponse).and_return({"simpleforecast"=>{"forecastday"=>[{"high"=>{"fahrenheit"=> "46","celsius"=> "8"}, "low"=>  {"fahrenheit"=> "36","celsius"=> "2"}, "conditions"=> "Chance of Rain", "icon_url"=> "http://icons-ak.wxug.com/i/c/k/chancerain.gif",}]}})
						subject.weatherInfoForLatlng(52.51704,13.38885,"forecast")
					}
					it 'has a high and low temperature forecasts' do
						high_lows = [{:high=>{:C=>8,:F=>46},:low=>{:C=>2,:F=>36}}]
						expect(subject.high_lows).to eq high_lows
					end
					it 'has a condition forecast' do
						conditions = [{:txt=>"Chance of Rain",:icon=>"http://icons-ak.wxug.com/i/c/k/chancerain.gif"}]
						expect(subject.conditions).to eq conditions
					end
					
				end
				it 'has a radar map' do
					pending
				end
			end
		end
end