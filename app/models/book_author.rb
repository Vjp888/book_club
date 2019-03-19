class BookAuthor < ApplicationRecord
  belongs_to :author
  belongs_to :book

  validates_presence_of :book_id, :author_id
end
