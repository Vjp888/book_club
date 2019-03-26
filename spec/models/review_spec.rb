require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :rating }
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :username }

    it { should validate_numericality_of(:rating).only_integer }
  end

  describe 'Relationships' do
    it { should belong_to :book }
  end

  describe 'Class methods' do
    describe '.most_active_users' do
      it 'returns array of arrays for top 3 reviewers, .first as username and .last as their review count' do
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

        active_users = Review.most_active_users

        expect(active_users[0].username).to eq('User3')
        expect(active_users[1].username).to eq('User4')
        expect(active_users[2].username).to eq('User2')

        expect(active_users[0].review_count).to eq(3)
        expect(active_users[1].review_count).to eq(2)
        expect(active_users[2].review_count).to eq(2)
      end
    end
    describe '.find_review' do
      it 'returns the first review by a username' do
        book_1 = Book.create(thumbnail: 'steve.jpg', title: 'Book 1 title', pages: 40, year_published: 1987)
        review_1 = book_1.reviews.create(rating: 1, title: 'Review_title', description: 'Review_description', username: 'User1')

        expect(Review.find_review(review_1.username)).to eq(review_1)
      end
    end

    describe '.sort_reviews' do
      it 'sorts and returns reviews based on given params' do
        author = Author.create(name: 'bob')
        book = author.books.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
        review_1 = book.reviews.create(rating: 5, title: "meh", description: "whoever", username: "bob", created_at: Date.parse("dec 1 2017"))
        review_2 = book.reviews.create!(rating: 4, title: "haha", description: "whatever", username: "bob", created_at: Date.parse("dec 2 2017"))
        review_3 = book.reviews.create!(rating: 3, title: "whatever", description: "harmful", username: "bob", created_at: Date.parse("dec 3 2017"))
        review_4 = book.reviews.create!(rating: 2, title: "is horrible", description: "carmin", username: "bob", created_at: Date.parse("may 4 2017"))

        expect_desc = [review_3, review_2, review_1, review_4]
        expect_asc = [review_4, review_1, review_2, review_3]
        expect_regular = [review_1, review_2, review_3, review_4]

        expect(Review.sort_reviews(review_1.username, "asc")).to eq(expect_asc)
        expect(Review.sort_reviews(review_1.username, "desc")).to eq(expect_desc)
        expect(Review.sort_reviews(review_1.username)).to eq(expect_regular)
      end
    end
  end
end
