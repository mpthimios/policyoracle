require 'rails_helper'

RSpec.describe "contracts/new", :type => :view do
  before(:each) do
    assign(:contract, Contract.new(
      :name => "MyString",
      :opening_price => "9.99",
      :market_id => "MyString"
    ))
  end

  it "renders new contract form" do
    render

    assert_select "form[action=?][method=?]", contracts_path, "post" do

      assert_select "input#contract_name[name=?]", "contract[name]"

      assert_select "input#contract_opening_price[name=?]", "contract[opening_price]"

      assert_select "input#contract_market_id[name=?]", "contract[market_id]"
    end
  end
end
