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
end
