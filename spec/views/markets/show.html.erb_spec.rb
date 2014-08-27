require 'rails_helper'

RSpec.describe "markets/show", :type => :view do
  before(:each) do
    @market = assign(:market, Market.create!(
      :name => "Name",
      :category => "Category",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/MyText/)
  end
end
