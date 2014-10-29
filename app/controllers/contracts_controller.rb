class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :edit, :update, :destroy]
  before_action :set_market, only: [:index, :new, :create]

  # GET /contracts
  # GET /contracts.json
  def index
    @contracts = @market.contracts.sorted
    @utransaction = Utransaction.new
    logger.debug current_user.inspect
  end

  # GET /contracts/1
  # GET /contracts/1.json
  def show

  end

  # GET /contracts/new
  def new
    @contract = Contract.new
  end

  # GET /contracts/1/edit
  def edit
  end

  # POST /contracts
  # POST /contracts.json
  def create
    #raise contract_params.inspect

    @contract = @market.contracts.build(contract_params)
    @contract.current_price = @contract.opening_price

    respond_to do |format|
      if @contract.save
        @market = @contract.market_id
        format.html { redirect_to market_path(@market), notice: 'Contract was successfully created.' }
        format.json { render :show, status: :created, location: @contract }
      else
        format.html { render :new }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contracts/1
  # PATCH/PUT /contracts/1.json
  def update
    respond_to do |format|
      if @contract.update(contract_params)
        format.html { redirect_to @contract, notice: 'Contract was successfully updated.' }
        format.json { render :show, status: :ok, location: @contract }
      else
        format.html { render :edit }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.json
  def destroy
    @contract.destroy
    respond_to do |format|
      format.html { redirect_to market_path(@contract.market), notice: 'Contract was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def after_close
    logger.debug params["correct_id"].inspect

    @winning_contract = Contract.find_by_id(params["correct_id"]).close
    flash[:notice] = "Market was successfully closed."
    
    redirect_to markets_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contract_params
      params.require(:contract).permit(:name, :opening_price)
    end

    def set_market
      @market = Market.find(params[:market_id])
    end
end
