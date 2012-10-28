#!/usr/bin/env ruby

require 'rexml/document'
require 'net/http'
require 'uri'
require 'tidy_ffi'
require 'sqlite3'
require './customer.rb'
require './nom.rb'
require './textmessage.rb'
include REXML



# initialize users
users = []
db = SQLite3::Database.new("food.db")
db.execute("select * from users").each do |user|
	userdata = db.execute("select * from t1 where cell=#{user[1]} limit 1").flatten
	temp = Customer.new(userdata[1],userdata[2],userdata[3])
	foods = []
	db.execute("select food from t1 where cell=#{user[1]}").each do |food|
		temp.add_food(food)
	end
	users << temp
end
db.close()

users.each do |u|
	foods = Nom::match_request(Nom::get_foods(),u.foods)
	if foods.size!=0
		puts "Notifying #{u.cell}"
		u.notify(foods);
	end
end