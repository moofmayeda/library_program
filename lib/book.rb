class Book

  attr_accessor :title
  attr_reader :id

  def initialize(attributes)
    @title = attributes[:title]
  end

  def save
    result = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM books;")
    books = []
    results.each do |result|
      attributes = {
        :title => result['title'],
        :id => result['id'].to_i
      }
      books << Book.new(attributes)
    end
    books
  end

  def ==(another_book)
    self.title == another_book.title
  end
end
