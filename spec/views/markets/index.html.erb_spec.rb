require 'rails_helper'

RSpec.describe "markets/index", :type => :view do
  before(:each) do
    assign(:markets, [
      Market.create!(
        :name => "Name",
        :category => "Category",
        :description => "MyText"
      ),
      Market.create!(
        :name => "Name",
        :category => "Category",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of markets" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
