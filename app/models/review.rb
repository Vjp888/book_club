class Review < ApplicationRecord
  belongs_to :book

  validates_presence_of :rating,
                        :title,
                        :description,
                        :username,
                        :book_id
end
