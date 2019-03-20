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

  describe 'Instance methods' do
    before(:each) do
      @book_1 = Book.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
      @book_1.reviews.create(rating: 5, title: 'Review_1_title', description: 'Review_1_description', username: 'Review_1_username')
      @book_1.reviews.create(rating: 4, title: 'Review_2_title', description: 'Review_2_description', username: 'Review_2_username')
    end

    context '.average_rating' do
      it 'returns the average rating of all reviews for the book' do
        expect(@book_1.average_rating).to eq(4.5)
      end
    end

    context '.review_count' do
      it 'returns the count of reviews for the book' do
        expect(@book_1.review_count).to eq(2)
      end
    end
  end
end
