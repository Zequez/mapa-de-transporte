# Load the rails application
require File.expand_path('../application', __FILE__)

Mime::Type.register "text/plain", :qps

# Initialize the rails application
Mdc::Application.initialize!
