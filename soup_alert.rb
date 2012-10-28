require 'net/http'

def getpage()
	useragent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.107 Safari/535.1"
	Net::HTTP.start('menus.tufts.edu', 80) do |http|
		return http.get('/foodpro/shortmenu.asp?sName=Tufts+Dining&locationNum=11&locationName=Dewick+MacPhie+Dining+Center&naFlag=1#', "User-Agent" => useragent).body
	end
end

def alert(soups)
	require 'net/smtp'
	Net::SMTP.start('smtp_server', 25, 'server', 'username', 'password', :plain) do |smtp|
		smtp.open_message_stream('email_address', "5555555555@VTEXT.COM") do |f|
		  f.puts 'From: Menu Alerts!'
		  f.puts 'To: 5555555555@VTEXT.COM'
		  f.puts 'Subject: Soup Alert'
		  f.puts 'Today you can look forward to:'
		  soups.each {|s| f.puts s}
		end
	end
end

def query()
	content = getpage()
	array = content.scan(/'','.*? Soup'\)"/)
	soups = []
	array.each do |x|
		soup = x.scan(/[A-Za-z ]*/)[4]
		if (soups.index(soup) == nil)
			soups << soup
		end
	end
	return soups
end

def match(array)
	array.each do |soup|
		if /[T|t]omato/.match(soup)
			return true
		end
	end
	return false
end

soups = query()

if match(soups)
#	alert(soups)
	puts "Sending alert."
end

#puts soups

alert(soups)
