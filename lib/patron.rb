class Patron
  attr_accessor :name
  attr_reader :id

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def save
    result = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM patrons;")
    patrons = []
    results.each do |result|
      attributes = {
        :name => result['name'],
        :id => result['id'].to_i
      }
      patrons << Patron.new(attributes)
    end
    patrons
  end

  def ==(another_patron)
    self.name == another_patron.name
  end

  def checkout(book, date)
    result = DB.exec("INSERT INTO checkouts (patron_id, book_id, due_date) VALUES (#{@id}, #{book.id}, '#{date}');")
    DB.exec("UPDATE copies SET copies = (copies - 1) WHERE book_id = #{book.id};")
  end

  def books
    results = DB.exec("SELECT * FROM checkouts JOIN books ON (book_id = books.id) WHERE patron_id = #{self.id};")
    hash = {}
    results.each do |result|
      due_date = result['due_date']
      hash[due_date] = Book.new({:id => result['id'].to_i, :title => result['title']})
    end
    hash
  end

  def return(book, date)
    book.add_copies(1)
    DB.exec("DELETE FROM checkouts WHERE book_id = #{book.id};")
    DB.exec("INSERT INTO returns (patron_id, book_id, date) VALUES (#{@id}, #{book.id}, '#{date}');")
  end

  def due_date_lookup(book)
    self.books.key(book)
  end
end
