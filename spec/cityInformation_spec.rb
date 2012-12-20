require 'spec_helper'

describe CityInformation do 
	subject {CityInformation.new(berlin)}
	let(:berlin) { City.new("Berlin")}
	its(:city) { should == berlin }
	
	context '#getInfo' do
		it 'can show information' do
				subject.city.country = "Germany"
				subject.city.country.should_not be_nil
				subject.should respond_to(:getInfo)
			end
			it 'returns an error if no country is set' do
				subject.city.country.should be_nil
				expect{subject.getInfo}.to raise_error()
			end
			it 'calls city locate' do
				subject.city.country = "Germany"
				subject.city.should_receive(:locate)
				subject.getInfo
			end
	end

	context '#weather' do
		
	end
end