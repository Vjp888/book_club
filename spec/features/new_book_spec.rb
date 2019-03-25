require 'rails_helper'

RSpec.describe 'As a user', type: :feature do
  it 'allows a user to create a new book' do
    visit books_path

    click_link 'Add a Book'

    expect(current_path).to eq(new_book_path)

    fill_in 'Title', with: 'Book 1'
    fill_in 'Pages', with: '1234'
    fill_in 'Year published', with: '1948'
    fill_in 'Thumbnail', with: 'https://www.libreture.com/static/images/book-placeholder.png'
    fill_in 'author_list', with: 'Steve, bob'

    click_button 'Create Book'
    book = Book.last

    expect(current_path).to eq(book_path(book))
    expect(page).to have_content("Title: Book 1")
    expect(page).to have_content("Page Count: 1234")
    expect(page).to have_content("Year Published: 1948")
    within '.authors' do
      expect(page).to have_link("Steve")
      expect(page).to have_link("Bob")
    end
  end

  it 'Will not create book if title is not unique' do
    author = Author.create(name: 'bobby')
    author.books.create(title: 'Book 1', pages: 1234, year_published: 4321, thumbnail: 'steve.jpg')

    visit books_path

    click_link 'Add a Book'

    expect(current_path).to eq(new_book_path)

    fill_in 'Title', with: 'Book 1'
    fill_in 'Pages', with: '1234'
    fill_in 'Year published', with: '1948'
    fill_in 'Thumbnail', with: 'https://www.libreture.com/static/images/book-placeholder.png'
    fill_in 'author_list', with: 'Steve, bob'

    click_button 'Create Book'

    expect(page).to have_field('Title')
    expect(page).to_not have_content('Book 1')
  end

  it 'Author name is unique' do
    author = Author.create(name: 'Bobby')
    author.books.create(title: 'book 1', pages: 1234, year_published: 4321, thumbnail: 'steve.jpg')

    visit books_path

    click_link 'Add a Book'

    expect(current_path).to eq(new_book_path)

    fill_in 'Title', with: 'book 1'
    fill_in 'Pages', with: '1234'
    fill_in 'Year published', with: '1948'
    fill_in 'Thumbnail', with: 'https://www.libreture.com/static/images/book-placeholder.png'
    fill_in 'author_list', with: 'Bobby'

    click_button 'Create Book'

    author_check = Author.last

    expect(author_check).to eq(author)
  end

  it 'will use a default thumbnail image if none is provided' do
    visit books_path

    click_link 'Add a Book'

    expect(current_path).to eq(new_book_path)

    fill_in 'Title', with: 'book 1'
    fill_in 'Pages', with: '1234'
    fill_in 'Year published', with: '1948'
    fill_in 'author_list', with: 'bobby, bob'

    click_button 'Create Book'

    book = Book.last
    expect(book.thumbnail).to eq("https://www.libreture.com/static/images/book-placeholder.png")
  end

  it 'shows error messages when no info is given' do
    author = Author.create(name: 'bobby')
    author.books.create(title: 'Book 1', pages: 1234, year_published: 4321, thumbnail: 'steve.jpg')

    visit books_path

    click_link 'Add a Book'

    expect(current_path).to eq(new_book_path)

    fill_in 'Title', with: 'Book 1'
    fill_in 'Pages', with: '1234'
    fill_in 'Thumbnail', with: 'https://www.libreture.com/static/images/book-placeholder.png'
    fill_in 'author_list', with: 'Steve, bob'

    click_button 'Create Book'

    expect(page).to have_content("Title has already been taken")
    expect(page).to have_content("Year published can't be blank")
  end
end
