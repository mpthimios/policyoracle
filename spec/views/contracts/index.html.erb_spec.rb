require 'rails_helper'

RSpec.describe "contracts/index", :type => :view do
  before(:each) do
    assign(:contracts, [
      Contract.create!(
        :name => "Name",
        :opening_price => "9.99",
        :market_id => "Market"
      ),
      Contract.create!(
        :name => "Name",
        :opening_price => "9.99",
        :market_id => "Market"
      )
    ])
  end

  it "renders a list of contracts" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Market".to_s, :count => 2
  end
end
