xml.feed do |feed|
  	feed.title = "PolicyOracle's Forecasts"
  	feed.updated @markets.maximum(:updated_at)
  	@markets.each do |market|
	  	feed.entry market do |entry|
	    	entry.title market.name
	    	entry.content market.description
	    	entry.url market_path(market)
	    	entry.author do |author|
	      		author.name "PolicyOracle"
	    	end
	  	end # end feed.entry
	end # end @markets.each
end