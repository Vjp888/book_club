class Book < ApplicationRecord
  has_many :book_authors
  has_many :authors, through: :book_authors
  has_many :reviews

  validates_numericality_of :pages, greater_than_or_equal_to: 0, only_integer: true
  validates_numericality_of :year_published, only_integer: true
  validates_uniqueness_of :title
  validates_presence_of :thumbnail,
                        :title,
                        :pages,
                        :year_published
end
