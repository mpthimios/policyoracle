require 'rails_helper'

RSpec.describe StaticPagesController, :type => :controller do
  render_views

  describe "GET home" do
    it "returns http success" do
      get :home
      response.should be_success
    end

    it { expect have_content('Home') }
  end

  describe "GET how_works" do
    it "returns http success" do
      get :how_works
      expect(response).to be_success
    end

    it { expect have_content('How Works') }
  end

  describe "GET trader_manual" do
    it "returns http success" do
      get :trader_manual
      expect(response).to be_success
    end

    it { expect have_content('Trader Manual') }
  end

  describe "GET faq" do
    it "returns http success" do
      get :faq
      expect(response).to be_success
    end

    it { expect have_content('FAQ') }
  end

  describe "GET contact" do
    it "returns http success" do
      get :contact
      expect(response).to be_success
    end

    it { expect have_content('Contact') }
  end

    describe "GET about" do
    it "returns http success" do
      get :about
      expect(response).to be_success
    end

    it { expect have_content('About') }
  end

end
