class Nom
	def self.get_foods()
		url = "http://menus.tufts.edu/foodpro/shortmenu.asp?sName=Tufts+Dining&locationNum=11&locationName=Dewick+MacPhie+Dining+Center&naFlag=1"
		
		raw_xml = Net::HTTP.get(URI.parse(url))
		
		xml = TidyFFI::Tidy.new(raw_xml, :show_body_only => 1, :output_xml => 1, :numeric_entities => 1).clean
		
		xml = REXML::Document.new xml
		root = xml.root
		
		tags = root.elements.to_a("//div/")
		tags.delete_if {|tag| tag.attributes["class"]!="shortmenurecipes"}
		foods = []
		for i in (0..tags.size-1)
			foods << tags[i].elements["span/a"].text
		end
		return foods.flatten
	end
	
	def self.matching_foods(food_array,target)
		matches = []
		for i in (1..(food_array.size-1))
			if (food_array[i].downcase =~ /#{Regexp.quote(target.downcase)}/)
				matches << food_array[i]
			end
		end
		return matches.flatten.uniq
	end
	
	def self.match_request(foods,requests)
		all_matches = []
		for i in (0..(requests.size-1))
			all_matches << matching_foods(foods.flatten,requests.flatten[i])
		end
		all_matches.flatten!
		
		all_matches.each do |x|
			x = x.gsub("\n"," ")
		end
		return all_matches
	end
end