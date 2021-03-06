require 'spec_helper'
describe City do
	subject { City.new("Berlin") }
	its(:name) { should == "Berlin" }
	its(:locator) { should_not be_nil }
	its(:weatherman) { should_not be_nil }
	its(:latitude) { should be_nil }
	its(:longitude) { should be_nil }
	its(:weather_today) { should_not be_nil }
	its(:weather_forecast) { should be_nil }
	
	context "Location" do
		let(:locator) { Cloudmade.new("5417a6b95e8544b7a8814ac874ebd27b") }
				
		it 'calls locate from locator' do
			location = {latitude: 3.56,longitude: 51.34}
			subject.locator.should_receive(:locate).with(subject.name).and_return(location)
			subject.locate
		end
		it 'changes lat and long' do
			location = {latitude: 3.56,longitude: 51.34}
			subject.locator.stub(:locate).with(subject.name).and_return(location)
			expect {
				expect { subject.locate }.to change { subject.latitude }.to be(location[:latitude])
				}.to change { subject.longitude }.to be(location[:longitude])
		end
	end
	
	context 'weather' do
		
		context '#todays_weather' do
			before {
				subject.weatherman.stub(:weatherInfoForLatlng)
				subject.weatherman.stub(:temperature).and_return({ C:2,F:46 })
				subject.weatherman.stub(:condition).and_return("Rain")
				subject.weatherman.stub(:icon_url).and_return("http://aurl.com")
			}
			it 'changes the weathers temperature' do
				expect{ subject.todays_weather }.to change{ subject.weather_today.temperature }
			end
			it 'changes the weater condition' do
				expect{ subject.todays_weather }.to change{ subject.weather_today.condition }
			end
			it 'changes the weater condition icon' do
				expect{ subject.todays_weather }.to change{ subject.weather_today.condition_icon }
			end
		end
		context '#get_weather_forecast' do
			it 'get the forecast for the next days ' do
				pending
				#subject.weatherman.should_receive(:weatherInfoForLatlng).with(@latitude,@longitude,"forecast")
				#subject.weather_forecast
			end
		end
	end
end