# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

BookAuthor.destroy_all
Author.destroy_all
Review.destroy_all
Book.destroy_all

options_hash = {col_sep: "\t", headers: true,
  header_converters: :symbol, converters: :numeric}

books = CSV.open('db/data/books.tsv', options_hash)
reviews = CSV.open('db/data/reviews.tsv', options_hash)
book_hashes = books.map{ |row| row.to_hash }
review_hashes  = reviews.map{ |row| row.to_hash }

book_hashes = book_hashes.each do |hash|
  hash[:authors] = hash[:authors].gsub(/[^a-zA-Z\s,]/,'').split(",")
end

book_hashes.each do |book|
  Book.create(
    thumbnail: book[:cover],
    title: book[:title],
    pages: book[:pages],
    year_published: book[:year],
    authors: book[:authors].map do |author|
      Author.find_or_create_by(name: author)
    end
  )
end

review_hashes.each do |review|
  Review.find_or_create_by(
    rating: review[:rating],
    title: review[:review_title],
    description: review[:review],
    username: review[:user],
    book: Book.where(title: review[:book_title]).first
  )
end
