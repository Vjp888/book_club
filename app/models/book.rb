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

  def average_rating
    reviews.average(:rating)
  end

  def review_count
    reviews.count
  end

  def remove_author(author)
    authors.where.not(id: author.id)
  end

  def grab_reviews(direction, limit)
    if direction == "top"
      self.reviews.order(rating: :desc, username: :desc).limit(limit)
    elsif direction == "bottom"
      self.reviews.order(rating: :asc, username: :desc).limit(limit)
    end
  end

  def self.top_three_rated
    # add argument of limit, order to dry this up
    # rename method
    joins(:reviews)
    .select('AVG(reviews.rating) as average_rating, books.*')
    .group(:id)
    .order('average_rating desc')
    .limit(3)
  end

  def self.bottom_three_rated
    joins(:reviews)
    .select('AVG(reviews.rating) as average_rating, books.*')
    .group(:id)
    .order('average_rating asc')
    .limit(3)
  end
end
