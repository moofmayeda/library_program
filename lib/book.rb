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
    DB.exec("INSERT INTO copies (book_id, copies) VALUES (#{@id}, 1);")
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

  def self.find(id)
    result = DB.exec("SELECT * FROM books WHERE id = #{id};").first
    attributes = {
      :title => result['title'],
      :id => result['id'].to_i
    }
    Book.new(attributes)
  end

  def self.search_by_title(query)
    results = DB.exec("SELECT * FROM books WHERE title LIKE '#{query}%';")
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

  def self.search_by_author(query)
    results = DB.exec("SELECT books.* FROM authors JOIN books_authors ON (authors.id = books_authors.author_id) JOIN books ON (books_authors.book_id = books.id) WHERE authors.name ~ '.*#{query}.*';")
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

  def copies
    DB.exec("SELECT copies.copies FROM books JOIN copies on (books.id = copies.book_id) WHERE books.id = #{self.id};").first['copies'].to_i
  end

  def add_copies(number)
    DB.exec("UPDATE copies SET copies = (copies + #{number}) WHERE book_id = #{self.id};")
  end
end
