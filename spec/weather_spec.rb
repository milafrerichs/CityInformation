require 'spec_helper'

describe Weather do
	its(:temperature) { should be_nil}
	its(:condition) { should be_nil}
	its(:condition_icon) { should be_nil}
	its(:high_low_temperature) { should be_nil}
	
	it 'returns temperature in celsius' do
		subject.stub(:temperature_celsius).and_return(2.5)
		subject.temperature_celsius.should == 2.5
	end
end