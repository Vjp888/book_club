require 'rails_helper'

RSpec.describe 'Book Show Page', type: :feature do
  it 'shows book information' do
    author_1 = Author.create(name: 'Author 1 name')
    author_2 = Author.create(name: 'Author 2 name')
    book_1 = Book.create(thumbnail: 'steve.jpg',
                                   title: 'Where The Wild Things Are',
                                   pages: 40,
                                   year_published: 1987, authors: [author_1, author_2])

    visit book_path(book_1.id)

    within ".book-information" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: Where The Wild Things Are")
      expect(page).to have_content("Page Count: 40")
      expect(page).to have_content("Year Published: 1987")
      expect(page).to have_link("Author 1 name", href: author_path(author_1))
      expect(page).to have_link("Author 2 name", href: author_path(author_2))
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

  describe 'Book show page statistics' do
    it 'shows top and bottom three reviews for a book' do
      author = Author.create(name: 'bob')
      book = author.books.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
      book.reviews.create(rating: 5, title: "meh", description: "whahhednd vijnvsihb", username: "bob")
      book.reviews.create(rating: 4, title: "haha", description: "whahhednd vijnvsihb", username: "rob")
      book.reviews.create(rating: 3, title: "whatever", description: "whahhednd vijnvsihb", username: "harbi")
      book.reviews.create(rating: 2, title: "is horrible", description: "whahhednd vijnvsihb", username: "stub")
      book.reviews.create(rating: 1, title: "super bad", description: "whahhednd vijnvsihb", username: "rude")

      visit book_path(book)

      within '.average-rating' do
        expect(page).to have_content("Rating: 3")
      end

      within '.book-stats' do
        within '.top-reviews' do
          expect(page).to have_content("Title: meh")
          expect(page).to have_content("Rating: 5")
          expect(page).to have_content("User: bob")
          expect(page).to have_link("bob")

          expect(page).to have_content("Title: haha")
          expect(page).to have_content("Rating: 4")
          expect(page).to have_content("User: rob")
          expect(page).to have_link("rob")

          expect(page).to have_content("Title: whatever")
          expect(page).to have_content("Rating: 3")
          expect(page).to have_content("User: harbi")
          expect(page).to have_link("harbi")

          expect(page).to_not have_content("is horrible")
          expect(page).to_not have_content("super bad")
        end

        within '.bottom-reviews' do
          expect(page).to have_content("super bad")
          expect(page).to have_content("Rating: 1")
          expect(page).to have_content("User: rude")
          expect(page).to have_link("rude")

          expect(page).to have_content("is horrible")
          expect(page).to have_content("Rating: 2")
          expect(page).to have_content("User: stub")
          expect(page).to have_link("stub")

          expect(page).to have_content("whatever")
          expect(page).to have_content("Rating: 3")
          expect(page).to have_content("User: harbi")
          expect(page).to have_link("harbi")

          expect(page).to_not have_content("haha")
          expect(page).to_not have_content("meh")
        end
      end
    end
    it 'Shows a message when no reviews are present' do
      author = Author.create(name: 'bob')
      book = author.books.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)

      visit book_path(book)

      expect(page).to_not have_content("Top Reviews")
      expect(page).to_not have_content("Bottom Reviews")
      expect(page).to have_link("Be the first to review this book")
    end

    it 'is able to show less than three reviews' do
      author = Author.create(name: 'bob')
      book = author.books.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
      book.reviews.create(rating: 5, title: "meh", description: "whahhednd vijnvsihb", username: "bob")
      book.reviews.create(rating: 4, title: "haha", description: "whahhednd vijnvsihb", username: "rob")

      visit book_path(book)

      within '.book-stats' do
        within '.top-reviews' do
          expect(page).to have_content("Title: meh")
          expect(page).to have_content("Rating: 5")
          expect(page).to have_content("User: bob")
          expect(page).to have_link("bob")

          expect(page).to have_content("Title: haha")
          expect(page).to have_content("Rating: 4")
          expect(page).to have_content("User: rob")
          expect(page).to have_link("rob")
        end
      end

      within '.book-stats' do
        within '.bottom-reviews' do
          expect(page).to have_content("Title: haha")
          expect(page).to have_content("Rating: 4")
          expect(page).to have_content("User: rob")
          expect(page).to have_link("rob")

          expect(page).to have_content("Title: meh")
          expect(page).to have_content("Rating: 5")
          expect(page).to have_content("User: bob")
          expect(page).to have_link("bob")
        end
      end
    end
  end
end
