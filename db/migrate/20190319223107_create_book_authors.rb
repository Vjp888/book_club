class CreateBookAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :book_authors do |t|
      t.references :book, foreign_key: true
      t.references :author, foreign_key: true
    end
  end
end
