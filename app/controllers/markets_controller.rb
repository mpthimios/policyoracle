class MarketsController < ApplicationController

  before_action :set_market, only: [:show, :edit, :update, :destroy]
  allow_cors :graph_data

  # GET /markets
  # GET /markets.json
  def index
    if params[:category]
      @markets = Market.where(category: params[:category])
    else
      @markets = Market.all
    end
    @markets = @markets.order("created_at DESC").paginate(page: params[:page], :per_page => 10)
    respond_to do |format|
      format.html { render :layout => 'application' }
      format.rss { render :layout => false }
      format.js
    end
  end

  # GET /markets/1
  # GET /markets/1.json
  def show
    @market = Market.find(params[:id])
    @contracts = @market.contracts.sorted
    @utransactions = @market.utransactions.last(5)
    @microposts = @market.microposts.order("created_at DESC").paginate(page: params[:page], :per_page => 8)
  end

  # GET /markets/new
  def new
    @market = Market.new
    contracts = @market.contracts.build
  end

  # GET /markets/1/edit
  def edit
  end

  # POST /markets
  # POST /markets.json
  def create
    new_market_params = market_params
    new_market_params[:published_date] = Date.strptime(market_params[:published_date],
                                                  '%m/%d/%Y %k:%M %p')
    new_market_params[:arbitration_date] = Date.strptime(market_params[:arbitration_date],
                                                   '%m/%d/%Y %k:%M %p')

    if new_market_params[:market_type] == "Yes/No"
      new_market_params[:contracts_attributes] = []
      new_market_params[:contracts_attributes] << {:name => "YES"}
      new_market_params[:contracts_attributes] << {:name => "NO"}
    end

    logger.debug new_market_params
    new_market_params.permit!
    @market = Market.new(new_market_params)
    @market.save
    respond_to do |format|
      if @market.save
        format.html { redirect_to @market, notice: 'Market was successfully created.' }
        format.json { render :show, status: :created, location: @market }
      else
        format.html { render :new }
        format.json { render json: @market.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /markets/1
  # PATCH/PUT /markets/1.json
  def update
    respond_to do |format|
      if @market.update(market_params)
        format.html { redirect_to @market, notice: 'Market was successfully updated.' }
        format.json { render :show, status: :ok, location: @market }
      else
        format.html { render :edit }
        format.json { render json: @market.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /markets/1
  # DELETE /markets/1.json
  def destroy
    @market.destroy
    respond_to do |format|
      format.html { redirect_to markets_url, notice: 'Market was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def close
    @market = Market.find(params[:id])
    @contracts = @market.contracts.sorted
  end

  def graph_data
    @market = Market.find(params[:id])
    render :json => @market.graph_data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_market
      @market = Market.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def market_params
      params.require(:market).permit(:name, :category, :market_type, :description, :published_date,
                                     :arbitration_date, :status, :tags, contracts_attributes: [:name])
    end
end
