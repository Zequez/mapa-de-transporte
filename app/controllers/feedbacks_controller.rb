class FeedbacksController < ApplicationController
  layout false

  def create
    @feedback = Feedback.new params[:feedback]
    @feedback.address = request.ip

    if @feedback.save
      render 'success'
    else
      L.l @feedback.errors
      render 'new'
    end
  end
end
