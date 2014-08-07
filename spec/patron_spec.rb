require 'spec_helper'

describe "Patron" do
  describe "initialize" do
    it "initializes an Patron with a hash of details" do
      test_patron = Patron.new({:name => "Pat Patron"})
      expect(test_patron).to be_a Patron
      expect(test_patron.name).to eq "Pat Patron"
    end
  end

  describe "save" do
    it "saves a Patron to the database" do
      test_patron = Patron.new({:name => "Pat Patron"})
      test_patron.save
      expect(Patron.all).to eq [test_patron]
    end
  end

  describe ".all" do
    it "returns an array of all Patrons" do
      test_patron = Patron.new({:name => "Pat Patron"})
      test_patron.save
      test_patron2 = Patron.new({:name => "Lou Patron"})
      test_patron2.save
      expect(Patron.all).to eq [test_patron, test_patron2]
    end
  end

  describe "==" do
    it "is the same Patron if the names are the same" do
      test_patron = Patron.new({:name => "Pat Patron"})
      test_patron.save
      test_patron2 = Patron.new({:name => "Pat Patron"})
      test_patron2.save
      expect(test_patron).to eq test_patron2
    end
  end

  describe "checkout" do
    it "checks out a book to a patron" do
      test_patron = Patron.new({:name => "Pat Patron"})
      test_patron.save
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      test_patron.checkout(test_book, '2014-8-12')
      expect(test_patron.books).to eq({'2014-08-12' => test_book})
    end
  end

  describe "books" do
    it "displays the books a patron has checked out" do
      test_patron = Patron.new({:name => "Pat Patron"})
      test_patron.save
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      test_patron.checkout(test_book, '2014-8-12')
      expect(test_patron.books).to eq({'2014-08-12' => test_book})
    end
  end

  describe "return" do
    it "returns a book to the library, increases copies by 1, adds record to returns table" do
      test_patron = Patron.new({:name => "Pat Patron"})
      test_patron.save
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      test_patron.checkout(test_book, '2014-08-12')
      test_patron.return(test_book, '2014-08-07')
      expect(test_patron.books).to eq({})
      expect(test_book.copies).to eq 1
    end
  end

  describe "due_date_lookup" do
    it "checks when a book is due" do
      test_patron = Patron.new({:name => "Pat Patron"})
      test_patron.save
      test_book = Book.new({:title => "Great Expectations"})
      test_book.save
      test_patron.checkout(test_book, '2014-08-12')
      expect(test_patron.due_date_lookup(test_book)).to eq '2014-08-12'
    end
  end
end
