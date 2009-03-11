require 'rubygems'
ENV['RAILS_ENV'] = "test"
require 'spec'
require 'mocha'
require 'ostruct'

# Some stuff to smooth over Rails-specific niceities.

unless defined?(ActiveRecord)
  # This is needed in the specs, but not really.
  module ActiveRecord
    class Base
    end
  end
end

unless Symbol.instance_methods.include?("to_proc")
  class Symbol
    def to_proc
      Proc.new { |*args| args.shift.__send__(self, *args) }
    end
  end
end

Spec::Runner.configure do |config|
  config.include(Sander6::CustomMatchers)
  config.mock_with :mocha
end