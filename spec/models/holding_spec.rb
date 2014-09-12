require 'spec_helper'

describe Holding, :type => :model do

	let(:user) { FactoryGirl.create(:user) }
  	before do
    	# This code is not idiomatically correct.
    	@holding = Holding.new(quantity: 50, user_id: user.id, contract_id: contract.id)
  	end

  	subject { @holding }

  	it { should respond_to(:quantity) }
  	it { should respond_to(:user_id) }
  	it { should respond_to(:contract_id) }

end
