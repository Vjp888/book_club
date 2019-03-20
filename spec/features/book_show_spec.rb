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

    visit book_path(book_1.id)

    within ".book-information" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: Where The Wild Things Are")
      expect(page).to have_content("Page Count: 40")
      expect(page).to have_content("Year Published: 1987")
      expect(page).to have_content("Author 1 name")
      expect(page).to have_content("Author 2 name")
    end
  end

  it 'shows a list of reviews for that book' do
    book_1 = Book.create(thumbnail: 'steve.jpg',
                         title: 'Where The Wild Things Are',
                         pages: 40,
                         year_published: 1987)
    review_1 = book_1.reviews.create(username: 'User1',
                                     rating: 5,
                                     title: 'Great book',
                                     description: 'This book was great!')
    review_2 = book_1.reviews.create(username: 'User2',
                                     rating: 2,
                                     title: 'Not great',
                                     description: 'This book was bad.')

    visit "/books/#{book_1.id}"

    within "#review-#{review_1.id}" do
      expect(page).to have_content("User1")
      expect(page).to have_content("5/5")
      expect(page).to have_content("Great book")
      expect(page).to have_content("This book was great!")
    end

    within "#review-#{review_2.id}" do
      expect(page).to have_content("User2")
      expect(page).to have_content("2/5")
      expect(page).to have_content("Not great")
      expect(page).to have_content("This book was bad.")
    end
  end
end
