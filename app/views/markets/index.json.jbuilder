json.array!(@markets) do |market|
  json.extract! market, :id, :name, :category, :description, :published_date, :arbitration_date
  json.url market_url(market, format: :json)
end
