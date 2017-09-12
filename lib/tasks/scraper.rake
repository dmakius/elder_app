namespace :scraper do
require 'open-uri'
  desc "Getting Data from Elder Site & Populating DB"
  task get_data: :environment do
  	puts 'scraping data'
  	links = []
	article_links = []

	startTime =  DateTime.now
	day = startTime.day
	month = startTime.month
	year = startTime.year
	puts "starting at date: " + startTime.strftime("%Y-%m-%dT%H:%M:%S")

	day2 = startTime.day - 1
	month2 = startTime.month
	year2 = startTime.year

	t = 0
	until t > 2
		if day === 0
		day = 30
		month -= 1
		if month == 2
			day = 28
		end
		if month <= 0
			month = 12
			year -= 1
		end
	end

	if day2 === 0
		day2 = 30
		month2 -= 1
		if month2 == 2
			day2 = 28
		end
		if month2 <= 0
			month2 = 12
			year2 -= 1
		end
	end
	dayOne = DateTime.new(year,month, day).strftime("%Y-%m-%dT%H:%M:%S")
 	dayTwo = DateTime.new(year2,month2, day2).strftime("%Y-%m-%dT%H:%M:%S")
 	puts "STARTING POINT: " + dayOne.to_s
 	puts "ENDING POINT: " + dayTwo.to_s
  	day -= 1
	day2 -= 1

	# Get links from website
	newPage = Nokogiri::HTML(open("http://elderofziyon.blogspot.com/search?updated-max=#{dayOne}-23:00&updated-min=#{dayTwo}-23:00&by-date=false"))
	content = newPage.css('h2.post-title.entry-title a')
	content.each do |link|
    	# puts link["href"]
    	if !links.include?(link["href"]) 
    		links.push(link["href"])
    		puts "LINK ADDED"
    	else
    		puts "DUPLICATE LINK FOUND: NOT ADDED"
    	end
	end 
	sleep 1.0 + rand
	t += 1
	end
	
	# Keep links that open article pics
	links.each do |link|
		if link.include?("link")
			article_links.push(link)
		end
	end 

	article_links.each do |page|
	puts "getting data from page #{page}"
	articlePage = Nokogiri::HTML(open(page))
	aTags = articlePage.css("div.post-body.entry-content > a")	
	aTags.each do |aTag|
		if aTag.to_s.include? "www"
			address = aTag.to_s.split("www.")[1]
		else
			address = aTag.to_s.split("//")[1]
		end
		publication = address.to_s.split(".")[0]

		article_date = page.split(".com/")[1].split("-")[0]
		date = DateTime.new(article_date[0...4].to_i,article_date[5...7].to_i, article_date[10...12].to_i)
		if aTag["href"] && aTag.text != "Share to Twitter" && aTag.text != "donate today" && aTag.text != "BlogThis!" && aTag.text != "Share to Facebook" && aTag.text != "Email This"
    		# If article not in data base then save
    		 if !Article.exists?(title: aTag.text)
				@article = Article.new
    		 	@article.title = aTag.text
    		 	@article.url = aTag["href"]
    		 	@article.publication = publication
    		 	@article.date = date
    		 	@article.save    		 
    		 end
    		 # If publication not in data base then save
    		 if !Publisher.exists?(name: publication)
    		 	@publisher = Publisher.new
    		 	@publisher.name = publication
    		 	@publisher.save
    		 end
		end
	end
	sleep 1.0 + rand
end	

end


  desc "Clears the Database"
  task clear_db: :environment do
  	puts 'clearing the database'
  	Article.destroy_all
  end

end
