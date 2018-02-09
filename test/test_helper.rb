$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'timecop'
require 'data_provider'
require 'minitest/autorun'

Dir[File.expand_path('../fixtures/*.rb', __FILE__)].each { |f| require f }
