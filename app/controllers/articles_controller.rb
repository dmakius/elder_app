class ArticlesController < ApplicationController
	def index
		puts "PARAMS:"
		date = ""
		newDate = ""
		puts params.keys
		if params.key?("date")
			puts "date present"
			params[:date].each do |d|
				l= d[1].length
				if l < 2
				 date += "0#{d[1]}-"
				else
				  date += "#{d[1]}-"
				 end
			end
			newDate = date.to_s.first(-1)
		end
		
		puts newDate
		@article = Article.paginate(:page => params[:page], :per_page => 30)
		@article = @article.where(publication: params["publication"]) if params["publication"].present?
		@article = @article.where("date = ?", newDate) if params["date"].present?
	end

	def new
	end

	def show
		
	end

	def edit
	end

	def destroy
	end
end
