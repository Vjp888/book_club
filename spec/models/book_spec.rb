require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :thumbnail }
    it { should validate_presence_of :title }
    it { should validate_presence_of :pages }
    it { should validate_presence_of :year_published }

    it { should validate_numericality_of(:pages).only_integer }
    it { should validate_numericality_of(:year_published).only_integer }
  end

  describe 'Relationships' do
    it { should have_many :book_authors }
    it { should have_many(:authors).through(:book_authors) }
    it { should have_many :reviews }
  end

  describe 'Class Methods' do
    describe 'Sorting books on index' do
      before :each do
        @author = Author.create(name: "Rickey Bobby")
        @book_2 = Book.create!(title: "book title 2", pages: 200, year_published: 1867, thumbnail: "steve.jpg", authors: [@author])
        @book_1 = Book.create!(title: "book title 1", pages: 100, year_published: 1980, thumbnail: "steve.jpg", authors: [@author])
        @book_3 = Book.create!(title: "book title 3", pages: 150, year_published: 1980, thumbnail: "steve.jpg", authors: [@author])
        @book_1.reviews.create!(title: "fantastic", description: "asdafd", rating: 5, username: 'bob')
        @book_1.reviews.create!(title: "horrible", description: "cdsubnvfkdf", rating: 1, username: 'bob')
        @book_1.reviews.create!(title: "meh", description: "meh", rating: 1, username: 'bob')
        @book_2.reviews.create!(title: "stupendous", description: "really", rating: 5, username: 'bob')
        @book_2.reviews.create!(title: "alright", description: "kinda", rating: 5, username: 'bob')
        @sort_1 = [@book_1, @book_2, @book_3]
        @sort_2 = [@book_2, @book_1, @book_3]
      end
      describe '.sort_books' do
        it 'sorts books by given params' do
          most_page = [@book_2, @book_3, @book_1]
          least_page = [@book_1, @book_3, @book_2]
          least_reviews = [@book_3, @book_2, @book_1]

          expect(Book.sort_books("top_reviews")).to eq(@sort_2)
          expect(Book.sort_books("bottom_reviews")).to eq(@sort_1)
          expect(Book.sort_books("most_pages")).to eq(most_page)
          expect(Book.sort_books("least_pages")).to eq(least_page)
          expect(Book.sort_books("most_reviews")).to eq(@sort_1)
          expect(Book.sort_books("least_reviews")).to eq(least_reviews)
          expect(Book.sort_books).to eq(Book.all)
        end
      end
      describe '.sort_by_review_count' do
        it 'it sorts books by reviews either asc or desc' do
          bottom_sort = [@book_3, @book_2, @book_1]
          expect(Book.sort_by_review_count("top")).to eq(@sort_1)
          expect(Book.sort_by_review_count("bottom")).to eq(bottom_sort)
        end
      end

      describe '.sort_by_avg_rating' do
        it 'it sorts books by average rating either asc or desc' do
          expect(Book.sort_by_avg_rating("top")).to eq(@sort_2)
          expect(Book.sort_by_avg_rating("bottom")).to eq(@sort_1)
        end
      end

      describe '.sort_by_page_count' do
        it 'it sorts books by page count either asc or desc' do
          sort_1 = [@book_1, @book_3, @book_2]
          sort_2 = [@book_2, @book_3, @book_1]
          expect(Book.sort_by_page_count("top")).to eq(sort_2)
          expect(Book.sort_by_page_count("bottom")).to eq(sort_1)
        end
      end
    end
  end

  describe 'Instance methods' do
    describe 'review ratings and counts' do
      before(:each) do
        @book_1 = Book.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
        @book_2 = Book.create(thumbnail: 'steve.jpg', title: 'Book 2 title', pages: 40, year_published: 1987)
        @book_1.reviews.create(rating: 5, title: 'Review_1_title', description: 'Review_1_description', username: 'Review_1_username')
        @book_1.reviews.create(rating: 4, title: 'Review_2_title', description: 'Review_2_description', username: 'Review_2_username')
      end

      context '.average_rating' do
        it 'returns the average rating of all reviews for the book' do
          expect(@book_1.average_rating).to eq(4.5)
        end

        it 'returns 0 if there are no reviews for the book' do
          expect(@book_2.average_rating).to eq(0)
        end
      end

      context '.review_count' do
        it 'returns the count of reviews for the book' do
          expect(@book_1.review_count).to eq(2)
        end
      end
    end

    describe '.remove_author' do
      it 'removes the given author from a book' do
        author = Author.create(name: 'Bob')
        author_2 = Author.create(name: 'Monkey')
        author_3 = Author.create(name: 'Steve')
        book_1 = Book.create(thumbnail: 'andrew.jpg', title: 'book title 2', pages: 456, year_published: 1978, authors: [author, author_2, author_3])

        expectation = book_1.remove_author(author)
        result = [author_2, author_3]

        expect(expectation).to eq(result)
      end
    end

    describe '.grab_reviews' do
      it 'returns the top or bottom number of reviews for a book' do
        author = Author.create(name: 'bob')
        book = author.books.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
        review_5 = book.reviews.create(rating: 5, title: "meh", description: "whahhednd vijnvsihb", username: "bob")
        review_4 = book.reviews.create(rating: 4, title: "haha", description: "whahhednd vijnvsihb", username: "rob")
        review_3 = book.reviews.create(rating: 3, title: "whatever", description: "whahhednd vijnvsihb", username: "harbi")
        review_2 = book.reviews.create(rating: 2, title: "is horrible", description: "whahhednd vijnvsihb", username: "stub")
        review_1 = book.reviews.create(rating: 1, title: "super bad", description: "whahhednd vijnvsihb", username: "rude")

        result_top = [review_5, review_4, review_3]
        result_bottom = [review_1, review_2, review_3]

        expect(book.grab_reviews('top', 3)).to eq(result_top)
        expect(book.grab_reviews('bottom', 3)).to eq(result_bottom)
      end
    end
  end

  describe 'Class Methods' do
    before :each do
      @book_1 = Book.create(thumbnail: 'steve.jpg', title: 'Book 1 title', pages: 40, year_published: 1987)
      @book_2 = Book.create(thumbnail: 'steve.jpg', title: 'Book 2 title', pages: 40, year_published: 1987)
      @book_3 = Book.create(thumbnail: 'steve.jpg', title: 'Book 3 title', pages: 40, year_published: 1987)
      @book_4 = Book.create(thumbnail: 'steve.jpg', title: 'Book 4 title', pages: 40, year_published: 1987)
      @book_5 = Book.create(thumbnail: 'steve.jpg', title: 'Book 5 title', pages: 40, year_published: 1987)

      @book_1.reviews.create(rating: 1, title: 'Review_title', description: 'Review_description', username: 'User1')

      @book_2.reviews.create(rating: 2, title: 'Review_title', description: 'Review_description', username: 'User2')
      @book_2.reviews.create(rating: 2, title: 'Review_title', description: 'Review_description', username: 'User3')

      @book_3.reviews.create(rating: 3, title: 'Review_title', description: 'Review_description', username: 'User2')

      @book_4.reviews.create(rating: 4, title: 'Review_title', description: 'Review_description', username: 'User3')
      @book_4.reviews.create(rating: 4, title: 'Review_title', description: 'Review_description', username: 'User4')

      @book_5.reviews.create(rating: 4, title: 'Review_title', description: 'Review_description', username: 'User3')
      @book_5.reviews.create(rating: 5, title: 'Review_title', description: 'Review_description', username: 'User4')
    end

    describe '.top_three_rated' do
      it 'returns the three highest rated books' do
        expect(Book.top_three_rated).to eq([@book_5, @book_4, @book_3])
      end
    end

    describe '.bottom_three_rated' do
      it 'returns the three lowest rated books' do
        expect(Book.bottom_three_rated).to eq([@book_1, @book_2, @book_3])
      end
    end
  end
end
