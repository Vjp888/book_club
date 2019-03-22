class ReviewsController < ApplicationController
  def new
    @book = Book.find(params[:book_id])
    @review = Review.new
  end

  def create
    @book = Book.find(params[:book_id])
    @review = @book.reviews.create(review_params)

    redirect_to book_path(@book)
  end

  private

  def review_params
    params.require(:review).permit(:username, :rating, :title, :description)
  end
end
