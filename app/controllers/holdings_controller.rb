class HoldingsController < ApplicationController
	before_action :signed_in_user

	def index
    	@holdings = current_user.holdings.all
    	@holdings = current_user.holdings.paginate(page: params[:page], :per_page => 10)
  	end

	def create
	    @holding = current_user.holdings.build(holdings_params)
	end

	private

    	def holdings_params
      		params.require(:holding).permit(:contract_id, :user_id, :quantity)
    	end
end
