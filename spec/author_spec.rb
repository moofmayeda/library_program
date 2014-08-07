require 'spec_helper'

describe "Author" do
  describe "initialize" do
    it "initializes an author with a hash of details" do
      test_author = Author.new({:name => "Charles Dickens"})
      expect(test_author).to be_a Author
      expect(test_author.name).to eq "Charles Dickens"
    end
  end

  describe "save" do
    it "saves a Author to the database" do
      test_author = Author.new({:name => "Charles Dickens"})
      test_author.save
      expect(Author.all).to eq [test_author]
    end
  end

  describe ".all" do
    it "returns an array of all Authors" do
      test_author = Author.new({:name => "Charles Dickens"})
      test_author.save
      test_author2 = Author.new({:name => "F. Scott Fitzgerald"})
      test_author2.save
      expect(Author.all).to eq [test_author, test_author2]
    end
  end

  describe "==" do
    it "is the same Author if the names are the same" do
      test_author = Author.new({:name => "Charles Dickens"})
      test_author.save
      test_author2 = Author.new({:name => "Charles Dickens"})
      test_author2.save
      expect(test_author).to eq test_author2
    end
  end
end
