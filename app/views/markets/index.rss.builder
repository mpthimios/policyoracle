xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "PolicyOracle"
    xml.description "An innovative information market"
    xml.link markets_path

    for market in @markets
      xml.item do
        xml.title market.name
        xml.description market.description
        xml.pubDate market.created_at.to_s(:rfc822)
        xml.link market_path(market)
        xml.guid market_path(market)
      end
    end
  end
end