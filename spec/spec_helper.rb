begin
  require 'spec/autorun'
rescue LoadError
  require 'rspec'
end
require File.expand_path(File.dirname(__FILE__) + '/../lib/core/machine.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/io/cli.rb')
