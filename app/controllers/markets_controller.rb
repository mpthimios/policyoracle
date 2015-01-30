class MarketsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_market, only: [:show, :edit, :update, :destroy]
  allow_cors :graph_data
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy, :close]

  # GET /markets
  # GET /markets.json
  def index
    @tenant = Tenant.current
    if params[:category]
      @markets = Market.where(category: params[:category], status: 1)
    else
      @markets = Market.where(status: 1)
    end
    if params[:status]
      @markets = Market.all.where(status: params[:status])
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
    @holdings = @market.holdings.where(user_id: current_user)
    @utransactions_all = @market.utransactions
    @utransactions_latest =@market.utransactions.last(3)
    @microposts = @market.microposts.order("created_at DESC").paginate(page: params[:page], :per_page => 4)
  end

  # GET /markets/new
  def new
    @market = Market.new
    contracts = @market.contracts.build
    @tenant = Tenant.current
  end

  # GET /markets/1/edit
  def edit
    @tenant = Tenant.current
  end

  # POST /markets
  # POST /markets.json
  def create
    new_market_params = market_params
    new_market_params[:tenant_id] = Tenant.current
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
      format.html { redirect_to markets_path, notice: 'Market was successfully destroyed.' }
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
                                     :arbitration_date, :tenant_id, :status, :tags, contracts_attributes: [:name])
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
