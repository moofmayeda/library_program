class Book

  attr_accessor :title
  attr_reader :id

  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
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

  def add_author(author)
    DB.exec("INSERT INTO books_authors (book_id, author_id) VALUES (#{self.id}, #{author.id});")
  end

  def authors
    results = DB.exec("SELECT authors.* FROM books JOIN books_authors on (books.id = books_authors.book_id) JOIN authors on (books_authors.author_id = authors.id) WHERE books.id = #{self.id};")
    @authors = []
    results.each do |result|
      attributes = {
        :name => result['name'],
        :id => result['id'].to_i
      }
      @authors << Author.new(attributes)
    end
    @authors
  end

  def ==(another_book)
    self.title == another_book.title
  end
end
