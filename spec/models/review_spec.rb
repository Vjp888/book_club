require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :rating }
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :username }

    it {should validate_numericality_of(:rating).only_integer}
  end

  describe 'Relationships' do
    it { should belong_to :book }
  end
end
