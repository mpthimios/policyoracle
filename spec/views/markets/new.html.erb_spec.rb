require 'rails_helper'

RSpec.describe "markets/new", :type => :view do
  before(:each) do
    assign(:market, Market.new(
      :name => "MyString",
      :category => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new market form" do
    render

    assert_select "form[action=?][method=?]", markets_path, "post" do

      assert_select "input#market_name[name=?]", "market[name]"

      assert_select "input#market_category[name=?]", "market[category]"

      assert_select "textarea#market_description[name=?]", "market[description]"
    end
  end
end
