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

  def self.most_active_users
    group(:username)
    .order("count_all desc", username: :desc)
    .limit(3)
    .count
    .map { |username, rating| [username, rating] }
  end
end
