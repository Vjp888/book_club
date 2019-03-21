require 'rails_helper'

RSpec.describe 'As a visitor', type: :feature do
  it 'shows all books by that author' do
    author = Author.create(name: 'bob')
    book_1 = author.books.create(thumbnail: 'steve.jpg', title: 'book title 1', pages: 40, year_published: 1987)
    book_2 = author.books.create(thumbnail: 'andrew.jpg', title: 'book title 2', pages: 456, year_published: 1978)

    visit author_path(author)

    within '.author-name' do
      expect(page).to have_content("Bob")
    end

    within "#book-#{book_1.id}" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: #{book_1.title}}")
      expect(page).to have_content("Page Count: #{book_1.pages}")
      expect(page).to have_content("Year Published: #{book_1.year_published}")
      expect(page).to_not have_content("Bob")
    end

    within "#book-#{book_2.id}" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: #{book_2.title}}")
      expect(page).to have_content("Page Count: #{book_2.pages}")
      expect(page).to have_content("Year Published: #{book_2.year_published}")
      expect(page).to_not have_content("Bob")
    end
  end

  it 'only shows co authors for each book' do
    author = Author.create(name: 'bob')
    author_2 = Author.create(name: 'monkey')
    author_3 = Author.create(name: 'steve')
    book_1 = author.books.create(thumbnail: 'steve.jpg', title: 'book title 1', pages: 40, year_published: 1987)
    book_2 = Book.create(thumbnail: 'andrew.jpg', title: 'book title 2', pages: 456, year_published: 1978, authors: [author, author_2, author_3])

    visit author_path(author)

    within "#book-#{book_1.id}" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: book title 1")
      expect(page).to have_content("Page Count: #{book_1.pages}")
      expect(page).to have_content("Year Published: #{book_1.year_published}")
      expect(page).to_not have_content("Bob")
    end

    within "#book-#{book_2.id}" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: #{book_2.title}")
      expect(page).to have_content("Page Count: #{book_2.pages}")
      expect(page).to have_content("Year Published: #{book_2.year_published}")
      expect(page).to_not have_content("Bob")
      expect(page).to have_content("Monkey")
      expect(page).to have_content("Steve")
    end
  end
end
