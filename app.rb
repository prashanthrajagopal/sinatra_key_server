# encoding: utf-8
require 'sinatra'

$key_list = {}
$key_list["available"] = []
$key_list["blocked"] = []
$time_keeper = {}

require_relative './init'
