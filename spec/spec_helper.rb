require File.join(File.dirname(__FILE__), '..', 'cityInformation.rb')
require File.join(File.dirname(__FILE__), '../models', 'city.rb')
require File.join(File.dirname(__FILE__), '../models', 'weather.rb')


RSpec.configure do |config|
	#config.filter_run_excluding online: true
	#config.run_all_with_everything_filtered = true
end