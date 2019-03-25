require 'rails_helper'

RSpec.describe "Delete a Review", type: :feature do
  context 'as a visitor to a users show page' do
    before :each do
      author = Author.create(name: 'bob')
      book_1 = author.books.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
      book_2 = author.books.create(thumbnail: 'steve.jpg', title: 'Book 2', pages: 40, year_published: 1987)
      @review_1 = book_1.reviews.create(rating: 5, title: "Review 1 title", description: "Review 1 description", username: "User1")
      @review_2 = book_2.reviews.create(rating: 3, title: "Review 2 title", description: "Review 2 description", username: "User1")

      visit user_path(@review_1)
    end

    it 'shows a link next to each review to delete the review' do
      within "#review-#{@review_1.id}" do
        expect(page).to have_link("Delete Review")
      end
    end

    it 'when I click delete, it returns me to a user show page' do
      within "#review-#{@review_1.id}" do
        click_on "Delete Review"
      end

      expect(current_path).to eq(user_path(@review_2))
    end

    it 'when I delete the last review for a user, it returns me to the books index page' do
      within "#review-#{@review_1.id}" do
        click_on "Delete Review"
      end

      within "#review-#{@review_2.id}" do
        click_on "Delete Review"
      end

      expect(current_path).to eq(books_path)
    end

    it 'when I delete a review, it no longer shows on the page' do
      expect(page).to have_content("Review 1 title")

      within "#review-#{@review_1.id}" do
        click_on "Delete Review"
      end

      expect(page).not_to have_content("Review 1 title")
    end
  end
end
