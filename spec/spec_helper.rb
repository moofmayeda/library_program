require 'pg'
require 'rspec'
require 'book'
require 'patron'
require 'author'

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.before(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM books_authors *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM copies *;")
    DB.exec("DELETE FROM checkouts *;")
    DB.exec("DELETE FROM returns *;")
  end
end
