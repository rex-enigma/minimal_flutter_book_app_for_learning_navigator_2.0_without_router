import 'package:flutter/material.dart';

void main() {
  runApp(const BookApp());
}

class Book {
  final String title;
  final String author;

  Book({required this.title, required this.author});
}

class BookApp extends StatefulWidget {
  const BookApp({super.key});

  @override
  State<BookApp> createState() => _BookAppState();
}

class _BookAppState extends State<BookApp> {
  Book? _selectedBook;

  List<Book> books = [
    Book(title: 'Syndicate', author: 'Josh'),
    Book(title: 'Left hand of Darkness', author: 'Palmer'),
    Book(title: 'kindred', author: 'wayne chester'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books App',
      home: Navigator(
        pages: [
          MaterialPage(
            key: const ValueKey('BooksListPage'),
            child: BookListScreen(
              books: books,
              onTapped: _handleOnBookTapped,
            ),
          ),
          if (_selectedBook != null) BookDetailsPage(book: _selectedBook),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }

          setState(() {
            _selectedBook = null;
          });

          return true;
        },
      ),
    );
  }

  void _handleOnBookTapped(Book book) {
    setState(() {
      _selectedBook = book;
    });
  }
}

class BookDetailsPage extends Page {
  final Book? book;

  BookDetailsPage({required this.book}) : super(key: ValueKey(book));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => BookDetailsScreen(book: book),
    );
  }
}

class BookListScreen extends StatelessWidget {
  final List<Book> books;
  final ValueChanged<Book> onTapped;

  const BookListScreen({super.key, required this.books, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book App'),
      ),
      body: ListView(
        children: [
          for (var book in books)
            ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () => onTapped(book),
            ),
        ],
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final Book? book;
  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book != null) ...[
              Text(
                book!.title,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                book!.author,
                style: Theme.of(context).textTheme.headline1,
              )
            ]
          ],
        ),
      ),
    );
  }
}
