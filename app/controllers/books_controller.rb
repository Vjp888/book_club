class BooksController < ApplicationController
  def index
    @books = Book.sort_books(params[:sorting_params])
    @reviews = Review.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.create(book_params)
    if @book.save
      params[:author_list].split(',').map do |author|
        @book.authors << Author.find_or_create_by(name: author.titleize.strip)
      end
      redirect_to book_path(@book)
    else
      @author_list = params[:author_list]
      render :new
    end
  end

  private

  def book_params
    bp = params.require(:book).permit(:title, :pages, :year_published, :thumbnail)
    bp[:thumbnail] = 'https://www.libreture.com/static/images/book-placeholder.png' unless bp[:thumbnail] != ""
    bp[:title].titleize
    bp
  end
end
