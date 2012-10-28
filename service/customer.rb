class Customer
	attr_accessor :cell, :provider, :password, :foods
	def initialize(inCell, inProvider, inPassword)
		@cell = inCell
		@provider = inProvider
		@password = inPassword
		@foods = []
	end
	def add_food(food)
		@foods << food
	end
	def print()
		puts "Cell: #{@cell}"
		puts "Provider: #{@provider}"
		puts "Password: #{@password}"
		puts "Foods: #{@foods.join(", ")}"
	end
	def notify(alert_foods)
		tm = TextMessage.new(6038288178,"verizon",alert_foods)
		tm.send()
	end
end