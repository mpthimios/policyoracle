class UtransactionsController < ApplicationController
	before_action :signed_in_user

  def new
    @contract = Contract.find(params['utransaction']['contract_id'])
    @market = @contract.market
    respond_to do |format|
      format.html {render "new", :layout => false }
      format.js
    end
  end

  def index
    @utransactions = current_user.utransactions.all
    @utransactions = current_user.utransactions.order("created_at DESC").paginate(page: params[:page], :per_page => 10)
    @holdings = current_user.holdings.all
  end


  def create
    session[:return_to] ||= request.referer
    logger.debug params['utransaction'].inspect
    case params['utransaction']['transaction_type']
      when 'Sell'
        params['utransaction']['transaction_type'] = "S"
      when 'Buy' 
        params['utransaction']['transaction_type'] = "B"
      when 'Submit'
        params['utransaction']['transaction_type'] = "B"
      else
        #do nothing
    end
    logger.debug params['utransaction'].inspect
    utransaction = Utransaction.new(utransaction_params)
    if utransaction.save
      redirect_to current_user
    else
      flash[:notice] = utransaction.errors.full_messages.to_sentence
      if utransaction.user.errors
        flash[:notice] = "Available points cant be negative"
      end
      redirect_to :back
    end
  end

  def simulate
    logger.debug params['utransaction'].inspect
    case params['utransaction']['transaction_type']
      when 'Sell'
        params['utransaction']['transaction_type'] = "S"
      when 'Buy'
        params['utransaction']['transaction_type'] = "B"
      else
        #do nothing
    end

    utransaction = Utransaction.new(utransaction_params)
    data = utransaction.simulate
    render :json => data
  end

  private
  # Using a private method to encapsulate the permissible parameters
  # is just a good pattern since you'll be able to reuse the same
  # permit list between create and update. Also, you can specialize
  # this method with per-user checking of permissible attributes.
  def utransaction_params
    params.require(:utransaction).permit(:transaction_type, :contract_id, :user_id, :quantity, :comment, :contract_current_value, :cost)
  end

end
