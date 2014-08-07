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
end
