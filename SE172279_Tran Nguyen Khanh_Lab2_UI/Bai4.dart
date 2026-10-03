// Parent class: Book
class Book {
  String title;
  int yearPublished;

  // Default constructor
  Book(this.title, this.yearPublished);

  // Named constructor with default values
  Book.untitled()
      : title = 'Untitled Book',
        yearPublished = 2020;

  // Describe the book
  void describe() {
    print('Book: $title - Year: $yearPublished');
  }
}

// Child class: EBook extends Book
class EBook extends Book {
  int fileSizeMb; // MB

  EBook(String title, int year, this.fileSizeMb) : super(title, year);

  // Override describe()
  @override
  void describe() {
    print('EBook: $title - Year: $yearPublished - Size: ${fileSizeMb}MB');
  }
}

void main() {
  // Create parent and child objects
  Book book1 = Book('The Hobbit', 1937);
  Book book2 = Book.untitled();
  EBook ebook = EBook('Dart in Action', 2023, 12);

  book1.describe();
  book2.describe();
  ebook.describe();
}
