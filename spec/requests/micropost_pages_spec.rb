require 'rails_helper'

RSpec.describe "MicropostPages", :type => :request do
  describe "GET /micropost_pages" do
    it "works! (now write some real specs)" do
      get micropost_pages_index_path
      expect(response.status).to be(200)
    end
  end
end
