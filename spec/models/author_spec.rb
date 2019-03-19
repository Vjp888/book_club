require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :name }
  end

  describe 'Relationships' do
    it { should have_many :book_authors }
    it { should have_many(:authors).through(:book_authors) }
  end
end
