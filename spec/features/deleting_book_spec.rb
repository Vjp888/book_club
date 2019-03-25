require 'rails_helper'

RSpec.describe 'when a user clicks the delete button', type: :feature do
  it 'deletes a book from an author that has other books and associated reviews' do
    author = Author.create(name: 'bob')
    book_1 = author.books.create(thumbnail: 'steve.jpg', title: 'Book 1', pages: 40, year_published: 1987)
    book_2 = author.books.create(thumbnail: 'steve.jpg', title: 'Book 2', pages: 40, year_published: 1987)
    book_1.reviews.create!(rating: 4, title: "haha", description: "whatever", username: "bob", created_at: Date.parse("dec 2 2017"))
    book_1.reviews.create!(rating: 4, title: "haha", description: "whatever", username: "bob", created_at: Date.parse("dec 2 2017"))

    visit book_path(book_1)

    expect(page).to have_link("Delete Book")
    expect(Review.count).to eq(2)

    click_link 'Delete Book'

    expect(current_path).to eq(books_path)
    expect(page).to_not have_content(book_1.title)
    expect(page).to have_content(book_2.title)
    expect(page).to have_content("bob")
    expect(Review.count).to eq(0)
  end
end
