require 'spec_helper'

describe "Markets", :type => :request do
  describe "GET /markets" do
    it "works! (now write some real specs)" do
      get markets_path
      expect(response.status).to be(200)
    end
  end
end
