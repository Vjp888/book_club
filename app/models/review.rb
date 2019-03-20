class Review < ApplicationRecord
  belongs_to :book
  validates_numericality_of :rating,
                            only_integer: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 5
  validates_presence_of :rating,
                        :title,
                        :description,
                        :username
end
