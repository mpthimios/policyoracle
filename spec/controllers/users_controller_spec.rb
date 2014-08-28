require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      expect be_success
    end

    it "should have the right title" do
      get 'new'
      expect have_selector('title', :content => "Sign up")
    end
  end

end
