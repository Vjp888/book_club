require 'rails_helper'

RSpec.describe 'Book index', type: :feature do
  it 'Show all book in database' do
    author = Author.create(name: 'bob')
    author_2 = Author.create(name: 'monkey')
    book_1 = author.books.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
    book_2 = author.books.create(thumbnail: 'bob.jpg', title: 'Whatever', pages: 230, year_published: 2019)
    book_3 = Book.create(thumbnail: 'andrew.jpg', title: 'meh', pages: 456, year_published: 1978)
    BookAuthor.create(book_id: book_3.id, author_id: author_2.id)
    BookAuthor.create(book_id: book_3.id, author_id: author.id)

    visit books_path

    within ".book-#{book_1.id}" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: where the wild things are")
      expect(page).to have_content("Page Count: 40")
      expect(page).to have_content("Year Published: 1987")
      expect(page).to have_link("bob")
    end
    
    within ".book-#{book_2.id}" do
      expect(page).to have_xpath("//img[@src='bob.jpg']")
      expect(page).to have_content("Title: Whatever")
      expect(page).to have_content("Page Count: 230")
      expect(page).to have_content("Year Published: 2019")
      expect(page).to have_link("bob")
    end

    within ".book-#{book_3.id}" do
      expect(page).to have_xpath("//img[@src='andrew.jpg']")
      expect(page).to have_content("Title: meh")
      expect(page).to have_content("Page Count: 456")
      expect(page).to have_content("Year Published: 1978")
      expect(page).to have_content("bob")
      expect(page).to have_link("monkey")
    end
  end
end
