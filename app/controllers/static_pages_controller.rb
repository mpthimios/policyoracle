class StaticPagesController < ApplicationController

  layout "static"

  def home
    unless Tenant.current.host == "www"
      @title = "Home"
      @market = Market.last
      @markets = Market.last(3)
      @utransactions = Utransaction.order("created_at DESC").first(6)
    else
      render action: :www, layout: false
    end
  end

  def www
    render layout: false
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
