class MicropostsController < ApplicationController
	before_action :signed_in_user

	def create
		@micropost = Micropost.new(micropost_params)
		
		respond_to do |format|
      		if @micropost.save
      			@market = @micropost.market_id
        		format.html { redirect_to market_path(@market, :anchor => "comment-#{@micropost.id}"), notice: 'Comment was successfully created.' }
        		format.json { render :show}
      		else
      			@market = @micropost.market_id
        		flash.now[:error] = 'Invalid length of comment'
        		format.json { render json: @micropost.market.errors, status: :unprocessable_entity }
      		end
    	end
	end

	def destroy
		@micropost = Micropost.find(params[:id])
		@market = @micropost.market_id
		if @micropost.present?
			@micropost.destroy
		end
    	redirect_to market_path(@market)
	end

	private

	def micropost_params
	  params.require(:micropost).permit(:content, :market_id, :user_id)
	end
end
