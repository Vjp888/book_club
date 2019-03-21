require 'rails_helper'

RSpec.describe 'Adding new review to book', type: :feature do
  context 'as a visitor to a book show page' do
    it 'shows a link to add a new review to the book' do
      book_1 = Book.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
      visit book_path(book_1)

      within ".reviews" do
        expect(page).to have_link('Add review', href: new_book_review_path(book_1))
      end
    end
  end
end
