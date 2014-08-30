require 'spec_helper'

describe "Static pages" do

  subject { page }

	describe "Home page" do
    before { visit '/home' }
  
    it { should have_content('Policy Oracle') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
  end

  describe "How Works page" do
    before { visit '/how_works' }

    it { should have_content('How Works') }
    it { should have_title(full_title('How Works')) }
  end

  describe "About page" do
    before { visit '/about' }

    it { should have_content('About') }
    it { should have_title(full_title('About')) }
  end

  describe "Trader Manual page" do
    before { visit '/trader_manual' }

    it { should have_content('Trader Manual') }
    it { should have_title(full_title('Trader Manual')) }    
  end

  describe "FAQ" do
    before { visit '/faq' }

    it { should have_content('FAQ') }
    it { should have_title(full_title('FAQ')) }  
  end

  describe "Contact page" do
    before { visit '/contact' }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }  
  end

end