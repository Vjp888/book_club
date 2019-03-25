require 'rails_helper'

RSpec.describe 'user clicks delete author link', type: :feature do
  it 'allows a user to delete an author and associated books' do
    author_1 = Author.create(name: 'bob')
    author_2 = Author.create(name: 'andrew')
    book_1 = author_1.books.create(thumbnail: 'steve.jpg', title: 'Book 1', pages: 40, year_published: 1987)
    book_2 = Book.create!(thumbnail: 'steve.jpg', title: 'Book 2', pages: 40, year_published: 1987, authors: [author_1, author_2])
    book_3 = author_2.books.create!(thumbnail: 'steve.jpg', title: 'Book 3', pages: 40, year_published: 1987)

    visit author_path(author_1)

    expect(page).to have_link("Delete Author")
    expect(author_2.books.count).to eq(2)

    click_link 'Delete Author'

    expect(current_path).to eq(books_path)

    expect(page).to_not have_content(author_1.name)
    expect(page).to_not have_content(book_2.title)
    expect(page).to_not have_content(book_1.title)
    expect(page).to have_content(author_2.name)
    expect(page).to have_content(book_3.title)
  end
end
