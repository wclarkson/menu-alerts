require 'gmail'

class TextMessage
	attr_accessor :to, :provider, :foods
	def initialize(inTo, inProvider, inFoods)
		@to = inTo
		@foods = inFoods
		@provider = inProvider
	end
	def send()
		@foods.each do |x|
			puts x
		end
		message = @foods.join("\n")
		domain = ""
		if (@provider=="sprint")
			domain = "messaging.sprintpcs.com"
		elsif (@provider=="verizon")
			domain = "vtext.com"
		elsif (@provider=="tmobile")
			domain = "tmomail.net"
		elsif (@provider=="att")
			domain = "txt.att.net"
		else
			puts "Invalid carrier."
		end

		send_to = @to.to_s + "@" + domain
		puts "Sending to address: #{send_to}"

		Gmail.new("dewick.menu.alerts","not_my_password") do |gmail|
			email = gmail.generate_message do
				to "#{send_to}"
				from "Dewick Menu Alerts"
				body "Today you can look forward to \n#{message}"
			end
			email.deliver!
		end

	end
end
