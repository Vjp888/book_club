class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string  :thumbnail
      t.string  :title
      t.integer :pages
      t.integer :year_published

      t.timestamps
    end
  end
end
