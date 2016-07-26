require 'rubygems'
require './tweet.rb'
require 'clockwork'
include Clockwork

every(10.minute, 'frequent_job') do
	PokemonTweet.new.update
end
