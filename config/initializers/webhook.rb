require File.dirname(__FILE__) + '/../../lib/webhook_parser.rb'

RspApp::Application.config.middleware.swap ActionDispatch::ParamsParser, RspApp::ParamsParser, :ignore_prefix => '/path/to/callback`'
