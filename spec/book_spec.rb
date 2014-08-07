require 'spec_helper'

describe "Book" do
  describe "initialize" do
    it "initializes a book with a hash of details" do
      test_book = Book.new({:title => "Great Expectations"})
      expect(test_book).to be_a Book
      expect(test_book.title).to eq "Great Expectations"
    end
  end

  describe "save" do
    it "saves a book to the database" do
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      expect(Book.all).to eq [test_book]
    end

    it "sets the number of copies to 1" do
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      expect(test_book.copies).to eq 1
    end
  end

  describe ".all" do
    it "returns an array of all books" do
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      test_book2 = Book.new({:title => "Great Gatsby"})
      test_book2.save
      expect(Book.all).to eq [test_book, test_book2]
    end
  end

  describe "==" do
    it "is the same book if the titles are the same" do
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      test_book2 = Book.new({:title => "Great Expectations"})
      test_book2.save
      expect(test_book).to eq test_book2
    end
  end

  describe "add_author" do
    it "adds a new author to the book" do
      test_author = Author.new({:name => "F. Scott Fitzgerald"})
      test_author.save
      test_book = Book.new({:title => "Great Gatsby"})
      test_book.save
      test_book.add_author(test_author)
      expect(test_book.authors).to eq [test_author]
    end
  end

  describe "copies" do
    it "pulls the number of copies from the database" do
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      expect(test_book.copies).to eq 1
    end
  end

  describe "add_copies" do
    it "changes the number of copies of a book in the database" do
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      test_book.add_copies(5)
      expect(test_book.copies).to eq 6
    end
  end

  describe ".find" do
    it "returns book object given the id" do
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      id = test_book.id
      expect(Book.find(id)).to eq test_book
    end
  end

  describe ".search_by_title" do
    it "returns a list of books that match the give search criteria" do
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      test_book2 = Book.new({:title => "Great Gatsby"})
      test_book2.save
      expect(Book.search_by_title("Great")).to eq [test_book, test_book2]
    end
  end

  describe ".search_by_author" do
    it "returns a list of books that match the give search criteria" do
      test_author = Author.new({:name => "F. Scott Fitzgerald"})
      test_author.save
      test_book1 = Book.new({:title => "Great Gatsby"})
      test_book1.save
      test_book2 = Book.new({:title => "Great Expectations"})
      test_book2.save
      test_author2 = Author.new({:name => "Another Author"})
      test_author2.save
      test_book3 = Book.new({:title => "Another book"})
      test_book3.save
      test_book1.add_author(test_author)
      test_book2.add_author(test_author)
      test_book3.add_author(test_author2)
      expect(Book.search_by_author("Fitzgerald")).to eq [test_book1, test_book2]
    end
  end
end
