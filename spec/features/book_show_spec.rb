require 'rails_helper'

RSpec.describe 'Book Show Page', type: :feature do
  it 'shows book information' do
    author_1 = Author.create(name: 'Author 1 name')
    author_2 = Author.create(name: 'Author 2 name')
    book_1 = author_1.books.create(thumbnail: 'steve.jpg',
                                   title: 'Where The Wild Things Are',
                                   pages: 40,
                                   year_published: 1987)
    BookAuthor.create(book_id: book_1.id, author_id: author_2.id)

    visit "/books/#{book_1.id}"

    within ".book-information" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: Where The Wild Things Are")
      expect(page).to have_content("Page Count: 40")
      expect(page).to have_content("Year Published: 1987")
      expect(page).to have_content("Author 1 name")
      expect(page).to have_content("Author 2 name")
    end
  end
end
