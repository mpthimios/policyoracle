class StaticPagesController < ApplicationController
  def home
    @title = "Home"
    @market = Market.last
    @markets = Market.last(5)
  end

  def how_works
    @title = "How Works"
  end

  def trader_manual
    @title = "Trader Manual"
  end

  def faq
    @title = "FAQ"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
end
