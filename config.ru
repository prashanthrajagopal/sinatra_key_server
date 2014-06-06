require 'rubygems'

root = ::File.dirname(__FILE__)
require ::File.join( root, 'app' )
run KeyServer.new
