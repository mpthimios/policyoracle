class BhistoriesController < ApplicationController
	before_action :signed_in_user

	def index
		@bhistories = current_user.bhistories.all
	   	@bhistories = current_user.bhistories.order("created_at DESC").paginate(page: params[:page], :per_page => 20)
	end
end
