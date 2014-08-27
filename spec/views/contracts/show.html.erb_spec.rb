require 'rails_helper'

RSpec.describe "contracts/show", :type => :view do
  before(:each) do
    @contract = assign(:contract, Contract.create!(
      :name => "Name",
      :opening_price => "9.99",
      :market_id => "Market"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Market/)
  end
end
