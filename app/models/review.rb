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
    select('COUNT(reviews.username) as review_count, reviews.username')
    .group(:username)
    .order('review_count desc, reviews.username desc')
    .limit(3)
  end

  def self.find_review(user_name)
    where(username: user_name).first
  end

  def self.sort_reviews(username, sort_params = "nothing")
    case sort_params
    when "asc"
      self.where(username: username).order(created_at: :asc)
    when "desc"
      self.where(username: username).order(created_at: :desc)
    else
      Review.where(username: username)
    end
  end
end
