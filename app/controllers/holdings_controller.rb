class HoldingsController < ApplicationController
	before_action :signed_in_user

	def create
	    @holding = current_user.holdings.build(holdings_params)
	    if params[:buy_button]
	    	if @holding.save
	      		flash[:success] = "Order created!"
	      		redirect_to user_path(@user)
	    	else
	      		render 'static_pages/home'
    		end
    	elsif params[:sell_button]

    	end
    		
	end

	private

    	def holdings_params
      		params.require(:holding).permit(:quantity)
    	end
end
