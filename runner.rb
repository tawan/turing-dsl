require 'optparse'
require './lib/io/cli.rb'
require 'rubygems'
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby runner.rb [options] [file ..]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-t TAPE", "--tape TAPE", "The machine will operate on this tape") do |tape|
    options[:tape] = tape
  end

  opts.on("-s SPEED", "--speed SPEED", "The machine will operate in given speed (default is 1)") do |speed|
    options[:speed] = speed
  end
  
end.parse!

Signal.trap("INT") {puts "prodded me" ; exit}

file = ARGV[0]
require file

m = Machine.find
m.extend CLI::SpeedSettings
m.extend CLI::OutputSettings
m.speed = options[:speed].to_f unless options[:speed].nil?
m.enter(m.initial_state)

