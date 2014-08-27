require 'rails_helper'

RSpec.describe "markets/edit", :type => :view do
  before(:each) do
    @market = assign(:market, Market.create!(
      :name => "MyString",
      :category => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit market form" do
    render

    assert_select "form[action=?][method=?]", market_path(@market), "post" do

      assert_select "input#market_name[name=?]", "market[name]"

      assert_select "input#market_category[name=?]", "market[category]"

      assert_select "textarea#market_description[name=?]", "market[description]"
    end
  end
end
