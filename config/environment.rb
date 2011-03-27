if ENV['RAILS_ENV'] == "production"
	ENV['GEM_PATH'] = '/home/boscolotshirt/.gems'
	Gem.clear_paths
end

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SampleApp::Application.initialize!
