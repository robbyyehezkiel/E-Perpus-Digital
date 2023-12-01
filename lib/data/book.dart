class Book {
  final String idBook; // Use the ID Book as a unique identifier
  final String title;
  final String category;

  Book({
    required this.idBook,
    required this.title,
    required this.category,
  });

  // Convert Book object to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'idBook': idBook,
      'title': title,
      'category': category,
    };
  }

  // Convert a Map to a Book object
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      idBook: map['idBook'],
      title: map['title'],
      category: map['category'],
    );
  }
}
