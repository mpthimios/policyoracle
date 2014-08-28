require 'spec_helper'

describe "LayoutLinks" do

	it "should have a Home page at '/'" do
		get '/'
		expect have_selector('title', :content => "Home")
	end

	it "should have a How Works page at '/'" do
		get '/'
		expect have_selector('title', :content => "How Works")
	end

	it "should have a Trader Manual page at '/'" do
		get '/'
		expect have_selector('title', :content => "Trader Manual")
	end

	it "should have a FAQ page at '/'" do
		get '/'
		expect have_selector('title', :content => "FAQ")
	end

	it "should have a Contact page at '/'" do
		get '/'
		expect have_selector('title', :content => "Contact")
	end

	it "should have a About page at '/'" do
		get '/'
		expect have_selector('title', :content => "About")
	end

	it "should have a sign up page at '/signup'" do
		get '/signup'
		expect have_selector('title', :content => "Sign Up")
	end

end


