class FeedbackController < ApplicationController
  def new
    feedback_params = Hash.new
    feedback_params[:name] = params[:name]
    feedback_params[:message] = params[:message]
    @feedback = Feedback.new(feedback_params)
    @feedback.save
    render :layout => false
  end

  def form
    render :layout => false
  end

end
