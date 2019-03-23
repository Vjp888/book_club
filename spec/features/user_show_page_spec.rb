require 'rails_helper'

RSpec.describe "A visitor clicks a username link", type: :feature do
  before :each do
    author = Author.create(name: 'bob')
    book = author.books.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
    @review_1 = book.reviews.create(rating: 5, title: "meh", description: "whoever", username: "bob")
    book.reviews.create(rating: 4, title: "haha", description: "whatever", username: "bob")
    book.reviews.create(rating: 3, title: "whatever", description: "harmful", username: "mark")
    book.reviews.create(rating: 2, title: "is horrible", description: "carmin", username: "stub")
    book.reviews.create(rating: 1, title: "super bad", description: "stevens two", username: "rude")
  end
  it 'Redirects them to the user show page' do
    visit user_index_path(user: "bob")

    expect(page).to have_content("bob")
    
    within "#review-#{@review_1.id}" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_content("Title: meh")
      expect(page).to have_content("Description: whoever")
      expect(page).to have_content("Rating: 5 out of 5")
      expect(page).to have_content("Title of Book: where the wild things are")
      expect(page).to have_content("Date Reviewed: #{@review_1.created_at.strftime("%m/%d/%Y")}")
      expect(page).to_not have_content("bob")
    end
    expect(page).to_not have_content("is horrible")
    expect(page).to_not have_content("super bad")
  end
end
