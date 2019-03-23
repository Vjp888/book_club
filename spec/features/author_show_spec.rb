require 'rails_helper'

RSpec.describe 'As a visitor to an author show page', type: :feature do
  it 'shows all books by that author' do
    author = Author.create(name: 'Bob')
    book_1 = author.books.create(thumbnail: 'steve.jpg', title: 'book title 1', pages: 40, year_published: 1987)
    book_2 = author.books.create(thumbnail: 'andrew.jpg', title: 'book title 2', pages: 456, year_published: 1978)

    visit author_path(author)

    within '.author-name' do
      expect(page).to have_content("Bob")
    end

    within "#book-#{book_1.id}" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: #{book_1.title}")
      expect(page).to have_link(book_1.title, href: book_path(book_1))
      expect(page).to have_content("Page Count: #{book_1.pages}")
      expect(page).to have_content("Year Published: #{book_1.year_published}")
      expect(page).to_not have_link("Bob")
    end

    within "#book-#{book_2.id}" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: #{book_2.title}")
      expect(page).to have_link(book_2.title, href: book_path(book_2))
      expect(page).to have_content("Page Count: #{book_2.pages}")
      expect(page).to have_content("Year Published: #{book_2.year_published}")
      expect(page).to_not have_link("Bob")
    end
  end

  it 'only shows co authors for each book' do
    author = Author.create(name: 'Bob')
    author_2 = Author.create(name: 'Monkey')
    author_3 = Author.create(name: 'Steve')
    book_1 = author.books.create(thumbnail: 'steve.jpg', title: 'book title 1', pages: 40, year_published: 1987)
    book_2 = Book.create(thumbnail: 'andrew.jpg', title: 'book title 2', pages: 456, year_published: 1978, authors: [author, author_2, author_3])

    visit author_path(author)

    within "#book-#{book_1.id}" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: book title 1")
      expect(page).to have_link("#{book_1.title}")
      expect(page).to have_content("Page Count: #{book_1.pages}")
      expect(page).to have_content("Year Published: #{book_1.year_published}")
      expect(page).to_not have_link("Bob")
    end

    within "#book-#{book_2.id}" do
      expect(page).to have_xpath("//img[@src='andrew.jpg']")
      expect(page).to have_content("Title: #{book_2.title}")
      expect(page).to have_link("#{book_2.title}")
      expect(page).to have_content("Page Count: #{book_2.pages}")
      expect(page).to have_content("Year Published: #{book_2.year_published}")
      expect(page).to_not have_content("Bob")
      expect(page).to have_link("Monkey")
      expect(page).to have_link("Steve")
    end
  end

  it 'shows co authors as links to their author show page' do
    author = Author.create(name: 'Bob')
    author_2 = Author.create(name: 'Monkey')
    author_3 = Author.create(name: 'Steve')
    book_1 = author.books.create(thumbnail: 'steve.jpg', title: 'book title 1', pages: 40, year_published: 1987)
    book_2 = Book.create(thumbnail: 'andrew.jpg', title: 'book title 2', pages: 456, year_published: 1978, authors: [author, author_2, author_3])

    visit author_path(author)

    within "#book-#{book_2.id}" do
      expect(page).to have_link("Monkey", href: author_path(author_2))
      expect(page).to have_link("Steve", href: author_path(author_3))
    end
  end

  it 'shows the top review information for each book on the page' do
    author = Author.create(name: 'bob')
    book = author.books.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
    book.reviews.create(rating: 3, title: "whatever", description: "whahhednd vijnvsihb", username: "harbi")
    book.reviews.create(rating: 2, title: "is horrible", description: "whahhednd vijnvsihb", username: "stub")
    book.reviews.create(rating: 1, title: "super bad", description: "whahhednd vijnvsihb", username: "rude")
    book.reviews.create(rating: 4, title: "haha", description: "whahhednd vijnvsihb", username: "rob")
    book.reviews.create(rating: 5, title: "meh", description: "whahhednd vijnvsihb", username: "bob")

    visit author_path(author)

    within "#book-#{book.id}" do
      expect(page).to have_content("Top Review:")
      expect(page).to have_content("Rating: 5 out of 5")
      expect(page).to have_content("Title: meh")
      expect(page).to have_content("User: bob")
      expect(page).to have_link("bob")
      click_link 'bob'
    end

    # expect(current_path).to eq(user_index_path) Renable when merged
  end
end
