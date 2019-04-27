require 'rails_helper'

RSpec.describe 'Book index', type: :feature do
  it 'Show all book in database' do
    author = Author.create(name: 'bob')
    author_2 = Author.create(name: 'monkey')
    book_1 = author.books.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
    book_2 = author.books.create(thumbnail: 'bob.jpg', title: 'Whatever', pages: 230, year_published: 2019)
    book_3 = Book.create(thumbnail: 'andrew.jpg', title: 'meh', pages: 456, year_published: 1978, authors: [author, author_2])

    visit books_path

    within "#book-#{book_1.id}" do
      expect(page).to have_xpath("//img[@src='steve.jpg']")
      expect(page).to have_link("where the wild things are", href: book_path(book_1))
      expect(page).to have_content("Page Count: #{book_1.pages}")
      expect(page).to have_content("Year Published: 1987")
      expect(page).to have_link(author.name, href: author_path(author))
    end

    within "#book-#{book_2.id}" do
      expect(page).to have_xpath("//img[@src='bob.jpg']") 
      expect(page).to have_link("Whatever", href: book_path(book_2))
      expect(page).to have_content("Page Count: 230")
      expect(page).to have_content("Year Published: 2019")
      expect(page).to have_link("bob", href: author_path(author))
    end

    within "#book-#{book_3.id}" do
      expect(page).to have_xpath("//img[@src='andrew.jpg']")
      expect(page).to have_link("meh", href: book_path(book_3))
      expect(page).to have_content("Page Count: 456")
      expect(page).to have_content("Year Published: 1978")
      expect(page).to have_link("bob", href: author_path(author))
      expect(page).to have_link("monkey", href: author_path(author_2))
    end
  end

  context 'next to each book title' do
    it 'shows the book average ratings' do
      book_1 = Book.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
      book_1.reviews.create(rating: 5, title: 'Review_1_title', description: 'Review_1_description', username: 'Review_1_username')
      book_1.reviews.create(rating: 4, title: 'Review_2_title', description: 'Review_2_description', username: 'Review_2_username')

      book_2 = Book.create(thumbnail: 'bob.jpg', title: 'Whatever', pages: 230, year_published: 2019)
      book_2.reviews.create(rating: 1, title: 'Review_3_title', description: 'Review_3_description', username: 'Review_3_username')
      book_2.reviews.create(rating: 2, title: 'Review_4_title', description: 'Review_4_description', username: 'Review_4_username')

      visit books_path

      within "#book-#{book_1.id}" do
        expect(page).to have_content('Average rating: 4.5')
      end

      within "#book-#{book_2.id}" do
        expect(page).to have_content('Average rating: 1.5')
      end
    end

    it 'shows the total number of reviews for the book' do
      book_1 = Book.create(thumbnail: 'steve.jpg', title: 'where the wild things are', pages: 40, year_published: 1987)
      book_1.reviews.create(rating: 5, title: 'Review_1_title', description: 'Review_1_description', username: 'Review_1_username')
      book_1.reviews.create(rating: 4, title: 'Review_2_title', description: 'Review_2_description', username: 'Review_2_username')

      book_2 = Book.create(thumbnail: 'bob.jpg', title: 'Whatever', pages: 230, year_published: 2019)
      book_2.reviews.create(rating: 1, title: 'Review_3_title', description: 'Review_3_description', username: 'Review_3_username')

      visit books_path

      within "#book-#{book_1.id}" do
        expect(page).to have_content('Total reviews: 2')
      end

      within "#book-#{book_2.id}" do
        expect(page).to have_content('Total reviews: 1')
      end
    end
  end

  it 'lets a user sort the book index page' do
    author = Author.create(name: "Rickey Bobby")
    book_2 = Book.create(title: "book title 2", pages: 200, year_published: 1867, thumbnail: "steve.jp", authors: [author])
    book_1 = Book.create(title: "book title 1", pages: 100, year_published: 1980, thumbnail: "steve.jpg", authors: [author])
    book_1.reviews.create(title: "fantastic", description: "asdafd", rating: 5, username: 'bob')
    book_1.reviews.create(title: "horrible", description: "cdsubnvfkdf", rating: 1, username: 'bob')
    book_1.reviews.create(title: "meh", description: "meh", rating: 3, username: 'bob')
    book_2.reviews.create(title: "stupendous", description: "really", rating: 5, username: 'bob')
    book_2.reviews.create(title: "alright", description: "kinda", rating: 4, username: 'bob')

    visit books_path

    within '#sort-nav' do
      click_link 'Top Reviews'
    end
    expect(page.all('.book-card')[0]).to have_content("book title 2")
    expect(page.all('.book-card')[1]).to have_content("book title 1")

    within '#sort-nav' do
      click_link "Bottom Reviews"
    end
      expect(page.all('.book-card')[0]).to have_content("book title 1")
      expect(page.all('.book-card')[1]).to have_content("book title 2")

    within '#sort-nav' do
      click_link "Most Pages"
    end
      expect(page.all('.book-card')[0]).to have_content("book title 2")
      expect(page.all('.book-card')[1]).to have_content("book title 1")

    within '#sort-nav' do
      click_link "Least Pages"
    end
      expect(page.all('.book-card')[0]).to have_content("book title 1")
      expect(page.all('.book-card')[1]).to have_content("book title 2")

    within '#sort-nav' do
      click_link "Most Reviews"
    end
      expect(page.all('.book-card')[0]).to have_content("book title 1")
      expect(page.all('.book-card')[1]).to have_content("book title 2")

    within '#sort-nav' do
      click_link "Least Reviews"
    end
      expect(page.all('.book-card')[0]).to have_content("book title 2")
      expect(page.all('.book-card')[1]).to have_content("book title 1")
  end

  describe 'book statistics section' do
    before :each do
      @book_1 = Book.create(thumbnail: 'steve.jpg', title: 'Book 1 title', pages: 40, year_published: 1987)
      @book_2 = Book.create(thumbnail: 'steve.jpg', title: 'Book 2 title', pages: 40, year_published: 1987)
      @book_3 = Book.create(thumbnail: 'steve.jpg', title: 'Book 3 title', pages: 40, year_published: 1987)
      @book_4 = Book.create(thumbnail: 'steve.jpg', title: 'Book 4 title', pages: 40, year_published: 1987)
      @book_5 = Book.create(thumbnail: 'steve.jpg', title: 'Book 5 title', pages: 40, year_published: 1987)

      @book_1.reviews.create(rating: 1, title: 'Review_title', description: 'Review_description', username: 'User1')

      @book_2.reviews.create(rating: 2, title: 'Review_title', description: 'Review_description', username: 'User2')
      @book_2.reviews.create(rating: 2, title: 'Review_title', description: 'Review_description', username: 'User3')

      @book_3.reviews.create(rating: 3, title: 'Review_title', description: 'Review_description', username: 'User2')

      @book_4.reviews.create(rating: 4, title: 'Review_title', description: 'Review_description', username: 'User3')
      @book_4.reviews.create(rating: 4, title: 'Review_title', description: 'Review_description', username: 'User4')

      @book_5.reviews.create(rating: 4, title: 'Review_title', description: 'Review_description', username: 'User3')
      @book_5.reviews.create(rating: 5, title: 'Review_title', description: 'Review_description', username: 'User4')

      visit books_path
    end

    it 'shows three of the highest rated books' do
      within "#highest-rated-books" do
        expect(page.all('li')[0]).to have_content("#{@book_5.title} (#{@book_5.average_rating} / 5)")
        expect(page.all('li')[1]).to have_content("#{@book_4.title} (#{@book_4.average_rating} / 5)")
        expect(page.all('li')[2]).to have_content("#{@book_3.title} (#{@book_3.average_rating} / 5)")
      end
    end

    it 'shows three of the worst-rated books' do
      within "#lowest-rated-books" do
        expect(page.all('li')[0]).to have_content("#{@book_1.title} (#{@book_1.average_rating} / 5)")
        expect(page.all('li')[1]).to have_content("#{@book_2.title} (#{@book_2.average_rating} / 5)")
        expect(page.all('li')[2]).to have_content("#{@book_3.title} (#{@book_3.average_rating} / 5)")
      end
    end

    it 'shows three users who have written the most reviews' do
      within '#most-active-users' do
        expect(page.all('li')[0]).to have_content("User3 (3)")
        expect(page.all('li')[1]).to have_content("User4 (2)")
        expect(page.all('li')[2]).to have_content("User2 (2)")
      end
    end
  end
end
