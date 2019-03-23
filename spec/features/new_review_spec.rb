require 'rails_helper'

RSpec.describe 'Adding new review to book', type: :feature do
  context 'as a visitor to a book show page' do
    it 'shows a link to add a new review to the book' do
      book_1 = Book.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
      visit book_path(book_1)

      within ".reviews" do
        expect(page).to have_link('Add review', href: new_book_review_path(book_1))
      end
    end

    describe 'when I click on the link Add review' do
      it 'takes me to a new review path' do
        book_1 = Book.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
        visit book_path(book_1)
        click_on 'Add review'

        expect(current_path).to eq(new_book_review_path(book_1))
      end
    end

    describe 'Happy path' do
      describe 'when I fill in the form and click submit' do
        before(:each) do
          @book_1 = Book.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
          visit book_path(@book_1)
          click_on 'Add review'

          @username = 'User1'
          @rating = 1
          @title = 'Great book'
          @description = 'I loved this book!'

          fill_in :review_username, with: @username
          fill_in :review_rating, with: @rating
          fill_in :review_title, with: @title
          fill_in :review_description, with: @description

          click_on 'Create Review'
        end

        it 'returns to that books show page' do
          expect(current_path).to eq(book_path(@book_1))
        end

        it 'shows new review on that books show page' do
          review_1 = Review.last
          within "#review-#{review_1.id}" do
            expect(page).to have_content(@username)
            expect(page).to have_content("#{@rating}/5")
            expect(page).to have_content(@title)
            expect(page).to have_content(@description)
          end
        end
      end
    end

    describe 'Sad path' do
      before :each do
        @book_1 = Book.create(thumbnail: 'steve.jpg', title: 'Gone with the wind', pages: 40, year_published: 1987)
        visit new_book_review_path(@book_1)
      end

      it 'when I click submit without any form information filled, it renders the form with error messages' do
        click_on 'Create Review'

        expect(current_path).to eq(book_reviews_path(@book_1))
        expect(page).to have_content('Rating is not a number')
        expect(page).to have_content("Rating can't be blank")
        expect(page).to have_content("Title can't be blank")
        expect(page).to have_content("Description can't be blank")
        expect(page).to have_content("Username can't be blank")
      end

      it 'when I enter an invalid rating, it shows an error message and rerenders the form' do
        username = 'User1'
        rating = 10
        title = 'Great book'
        description = 'I loved this book!'

        fill_in :review_username, with: username
        fill_in :review_rating, with: rating
        fill_in :review_title, with: title
        fill_in :review_description, with: description

        click_on 'Create Review'

        expect(current_path).to eq(book_reviews_path(@book_1))
        expect(page).to have_content("Rating must be less than or equal to 5")
      end

      it 'converts username to titlecase before saving' do
        username = 'john doe'
        rating = 5
        title = 'Great book'
        description = 'I loved this book!'

        fill_in :review_username, with: username
        fill_in :review_rating, with: rating
        fill_in :review_title, with: title
        fill_in :review_description, with: description

        click_on 'Create Review'
        review = Review.last

        expect(review.username).to eq(username.titleize)

        within "#review-#{review.id}" do
          expect(page).to have_content('John Doe')
        end
      end
    end
  end
end
