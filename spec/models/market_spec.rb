require 'spec_helper'

describe Market do

   	before do
    	@market = Market.new(name: "Example Market", description: "Example Description",
                     published_date: "foobar", password_confirmation: "foobar")
  	end

  	subject { @user }
end
