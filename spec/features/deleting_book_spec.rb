require 'rails_helper'

RSpec.describe 'when a user clicks the delete button', type: :feature do
  describe 'happy path' do
    it 'deletes a book from an author that has other books' do
      author = Author.create(name: 'bob')
      book_1 = author.books.create(thumbnail: 'steve.jpg', title: 'Book 1', pages: 40, year_published: 1987)
      book_2 = author.books.create(thumbnail: 'steve.jpg', title: 'Book 2', pages: 40, year_published: 1987)

      visit book_path(book_1)

      expect(page).to have_link("Delete Book")
      click_link 'Delete Book'

      expect(current_path).to eq(books_path)
      expect(page).to_not have_content(book_1.title)
      expect(page).to have_content(book_2.title)
    end
  end
end
