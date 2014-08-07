require 'pg'
require './lib/book'
require './lib/patron'
require './lib/author'
require 'date'

DB = PG.connect({:dbname => 'library'})

@current_patron = nil
@due_date = Date.new(2014,8,20)

def welcome
  system("clear")
  puts "WELCOME TO THE LIBRARY"
  ws
  main_menu
end

def ws
  puts "\n"
end

def patron_login
  puts "Enter your full name or 'n' for new member"
  input = gets.chomp.upcase
  case input
  when 'N'
    create_patron
  else
    @current_patron = Patron.find(input)
    patron_menu
  end
  main_menu
end

def patron_menu
  puts "S > Search for a book"
  puts "N > New library member"
  puts "C > Check out a book"
  case gets.chomp.downcase
  when 's'
    search_menu
  when 'n'
    create_patron
  when 'c'
    search_by_title
    puts "Enter the BOOK NUMBER to check it out:"
    checkout(gets.chomp.to_i)
  end
  patron_menu
end

def search_menu
  puts "T > Search by title"
  puts "A > Search by author"
  case gets.chomp.downcase
  when 't'
    search_by_title
  when 'a'
    search_by_author
  end
  patron_menu
end

def checkout(id)
  @current_patron.checkout(Book.find(id), @due_date.to_s)
  view_checkouts
  @due_date += 1
end

def view_checkouts
  @current_patron.books.each do |date, book|
    view_book(book)
    puts "Due: " + date
    ws
  end
end

def create_patron
  puts "Enter your name"
  new_patron = Patron.new({:name => gets.chomp.upcase})
  new_patron.save
  puts "Welcome to the library, #{new_patron.name}!"
  @current_patron = new_patron
end

def search_by_title
  puts "Enter a title to search for:"
  Book.search_by_title(gets.chomp).each do |book|
    view_book(book)
  end
end

def search_by_author
  puts "Enter the name of an author:"
  Book.search_by_author(gets.chomp).each do |result|
    view_book(result)
  end
end

def view_book(book)
  puts "BOOK NUMBER: " + book.id.to_s
  puts "TITLE: " + book.title
  book.authors.each do |author|
    puts "AUTHOR: " + author.name
  end
  puts "COPIES AVAILABLE: " + book.copies.to_s
end

def main_menu
  puts "P > Log in as a patron."
  puts "L > Log in as a librarian."
  case gets.chomp.downcase
  when 'p'
    patron_login
  when 'l'
    librarian_menu
  end
end

welcome
