require 'csv'
require 'pry'

options_hash = {col_sep: "\t", headers: true,
  header_converters: :symbol, converters: :numeric}

books = CSV.open('books.tsv', options_hash)
reviews = CSV.open('reviews.tsv', options_hash)
book_hashes = books.map{ |row| row.to_hash }
review_hashes  = reviews.map{ |row| row.to_hash }

book_hashes = book_hashes.each do |hash|
  hash[:authors] = hash[:authors].gsub(/[^a-zA-Z\s,]/,'').split(",")
end

binding.pry
