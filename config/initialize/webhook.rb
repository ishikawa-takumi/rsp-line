require File.dirname(__FILE__) + '/../../lib/webhook_parser.rb'

p "now initializer @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
MyApp::Application.config.middleware.swap ActionDispatch::ParamsParser, MyApp::ParamsParser, :ignore_prefix => '/path/to/webhook'
