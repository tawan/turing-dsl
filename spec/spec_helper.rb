begin
  require 'spec/autorun'
rescue LoadError
  require 'rspec'
end
require File.expand_path(File.dirname(__FILE__) + '/../lib/machine.rb')
