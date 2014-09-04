FactoryGirl.define do
	factory :user do
    	sequence(:name)  { |n| "Person #{n}" }
    	sequence(:email) { |n| "person_#{n}@example.com"}
    	password "test123"
    	password_confirmation "test123"

	    factory :admin do
    	  admin true
    	end
  	end

  	factory :market do
 		name "example name"
 		description "example description"
 		sequence(:published_date) { |n| Time.now + n.weeks }
 		sequence(:arbitration_date) { |n| Time.now + n.weeks + 1.hour }

 		factory :market_with_contract do
 			after_create do |market|
 				create(:contract, market: market)
 			end
 		end
 	end

 	factory :contract do
 		name "price"
 		market
 		opening_price
 	end

 	factory :holding do
 		association :user
 		association :contract
 	end
end