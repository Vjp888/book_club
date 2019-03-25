class ReviewsController < ApplicationController

  def show
    # binding.pry
    review = Review.find(params[:id])
    @reviews = Review.sort_reviews(review.username, params[:sort_params])
    @user = review.username
  end

  def new
    @book = Book.find(params[:book_id])
    @review = Review.new
  end

  def create
    @book = Book.find(params[:book_id])
    @review = @book.reviews.new(review_params)

    if @review.save
      redirect_to book_path(@book)
    else
      render :new
    end
  end

  private

  def review_params
    rp = params.require(:review).permit(:username, :rating, :title, :description)
    rp[:username] = rp[:username].titleize
    rp
  end
end
