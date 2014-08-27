json.array!(@contracts) do |contract|
  json.extract! contract, :id, :name, :opening_price, :market_id
  json.url contract_url(contract, format: :json)
end
