require 'rails_helper'

RSpec.describe "contracts/edit", :type => :view do
  before(:each) do
    @contract = assign(:contract, Contract.create!(
      :name => "MyString",
      :opening_price => "9.99",
      :market_id => "MyString"
    ))
  end

  it "renders the edit contract form" do
    render

    assert_select "form[action=?][method=?]", contract_path(@contract), "post" do

      assert_select "input#contract_name[name=?]", "contract[name]"

      assert_select "input#contract_opening_price[name=?]", "contract[opening_price]"

      assert_select "input#contract_market_id[name=?]", "contract[market_id]"
    end
  end
end
