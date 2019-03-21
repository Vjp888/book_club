require 'rails_helper'

RSpec.describe 'Navigation Bar', type: :feature do
  context 'As a visitor to the welcome page' do
    it 'shows a navigation bar with a home link' do
      visit root_path

      within 'nav' do
        expect(page).to have_link('Home', href: root_path)
        expect(page).to have_link('Browse Books', href: books_path)
      end
    end
  end

  context 'As a visitor to the books page' do
    it 'shows a navigation bar with a home link' do
      visit books_path

      within 'nav' do
        expect(page).to have_link('Home', href: root_path)
        expect(page).to have_link('Browse Books', href: books_path)
      end
    end
  end
end
