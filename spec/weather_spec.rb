require 'spec_helper'

describe Weather do
	its(:temperature) { should be_nil}
	its(:condition) { should be_nil}
	its(:condition_icon) { should be_nil}
	its(:high_low_temperature) { should be_nil}
end