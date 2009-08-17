require 'rubygems'
ENV['RAILS_ENV'] = "test"
require 'spec'
require 'mocha'
require 'ostruct'

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
