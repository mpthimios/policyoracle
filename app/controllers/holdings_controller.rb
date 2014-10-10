class HoldingsController < ApplicationController
	before_action :signed_in_user

	def index
    	@holdings = current_user.holdings.all
    	@holdings = current_user.holdings.order("created_at DESC").paginate(page: params[:page], :per_page => 10)
  	end

	def create
	    @holding = current_user.holdings.build(holdings_params)
	end

	def cash_out
		@holding = Holding.find(params[:holding_id]).sell

		#@holding.destroy
	    respond_to do |format|
	    	format.html { redirect_to current_user, notice: 'Holding was succesfully sold.' }
	    	format.json { head :no_content }
    	end
	end

	private

    	def holdings_params
      		params.require(:holding).permit(:contract_id, :user_id, :quantity)
    	end
end
