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
    if reviews.count > 0
      reviews.average(:rating)
    else
      0
    end
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

  def self.sort_by_avg_rating(direction)
    case direction
    when "top"
      self.left_outer_joins(:reviews)
          .select('books.*, avg(reviews.rating) as rating_average')
          .group(:id)
          .order('rating_average DESC nulls last')
    when "bottom"
      self.left_outer_joins(:reviews)
          .select('books.*, avg(reviews.rating) as rating_average')
          .group(:id)
          .order('rating_average ASC nulls last')
    end
  end

  def self.sort_by_review_count(direction)
    case direction
    when "top"
      self.left_outer_joins(:reviews)
          .select('books.*, count(reviews) as review_count')
          .group(:id)
          .order('review_count DESC')
    when "bottom"
      self.left_outer_joins(:reviews)
          .select('books.*, count(reviews) as review_count')
          .group(:id)
          .order('review_count ASC')
    end
  end

  def self.sort_by_page_count(direction)
    case direction
    when "top"
      self.order(pages: :desc)
    when "bottom"
      self.order(pages: :asc)
    end
  end

  def self.sort_books(sort_param = "nothing")
    case sort_param
    when "top_reviews"
      self.sort_by_avg_rating("top")
    when "bottom_reviews"
      self.sort_by_avg_rating("bottom")
    when "most_pages"
      self.sort_by_page_count('top')
    when "least_pages"
      self.sort_by_page_count("bottom")
    when "most_reviews"
      self.sort_by_review_count("top")
    when "least_reviews"
      self.sort_by_review_count("bottom")
    else
      self.all
    end
  end

  def self.top_three_rated
    # add argument of limit, order to dry this up
    # rename method
    joins(:reviews)
    .select('AVG(reviews.rating) as avg_rating, books.*')
    .group(:id)
    .order('avg_rating desc')
    .limit(3)
  end

  def self.bottom_three_rated
    joins(:reviews)
    .select('AVG(reviews.rating) as avg_rating, books.*')
    .group(:id)
    .order('avg_rating asc')
    .limit(3)
  end
end
