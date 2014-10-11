class UtransactionsController < ApplicationController
	before_action :signed_in_user

  def index
    @utransactions = current_user.utransactions.all
    @utransactions = current_user.utransactions.order("created_at DESC").paginate(page: params[:page], :per_page => 10)
  end


  def create
    logger.debug params['utransaction'].inspect
    case params['utransaction']['transaction_type']
      when 'Sell'
        params['utransaction']['transaction_type'] = "S"
      when 'Buy'
        params['utransaction']['transaction_type'] = "B"
      else
        #do nothing
    end
    logger.debug params['utransaction'].inspect
    utransaction = Utransaction.create!(utransaction_params)
    redirect_to current_user
  end

  private
  # Using a private method to encapsulate the permissible parameters
  # is just a good pattern since you'll be able to reuse the same
  # permit list between create and update. Also, you can specialize
  # this method with per-user checking of permissible attributes.
  def utransaction_params
    params.require(:utransaction).permit(:transaction_type, :contract_id, :user_id, :quantity, :contract_current_value, :cost)
  end

end
