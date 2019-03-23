class ReviewsController < ApplicationController
  def index
    @reviews = Review.where(username: params[:user])
    @user = @reviews.first.username
  end
end
