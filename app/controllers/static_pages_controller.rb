class StaticPagesController < ApplicationController

  layout "static"

  def home
    @title = "Home"
    @market = Market.last
    @markets = Market.last(5)
    @utransactions = Utransaction.last(8)
  end

  def howtoplay
    @title = "How to Play"
  end

  def player_manual
    @title = "Player Manual"
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
