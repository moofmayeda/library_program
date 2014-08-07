class Author
  attr_accessor :name
  attr_reader :id

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def save
    result = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM authors;")
    authors = []
    results.each do |result|
      attributes = {
        :name => result['name'],
        :id => result['id'].to_i
      }
      authors << Author.new(attributes)
    end
    authors
  end

  def ==(another_book)
    self.name == another_book.name
  end

  def edit(new_name)
    @name = new_name
    DB.exec("UPDATE authors SET name = '#{new_name}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM authors WHERE id = #{@id};")
  end
end
