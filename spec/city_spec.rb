require 'spec_helper'
describe City do
	subject { City.new("Berlin")}
	its(:name) { should == "Berlin" }
	its(:latitude) { should be_nil}
	its(:longitude) { should be_nil}
	
	context "Location" do
		let(:locator) { Cloudmade.new("APIKEY") }
		it 'has a locator' do
			subject.locator = locator
		end
		
		it 'returns latitude and longitude' do
			
			location = stub(latitude:3.56,longitude:51.34)
			subject.locator.should_receive(:locate).with(subject.name).and_return(location)
			expect {
				expect { subject.locate }.to change { subject.latitude }.to be(location.latitude)
				}.to change { subject.latitude }.to be(location.latitude)
			
		end
		
	end
	
	context 'weather' do
		
	end
end