import 'package:flutter/material.dart';
import 'package:e_perpus_app/book/book_add.dart';
import 'package:e_perpus_app/book/book_detail.dart';
import 'package:e_perpus_app/book/book_edit.dart';
import 'package:e_perpus_app/data/book.dart';
import 'package:e_perpus_app/database_helper.dart';

class BookDataPage extends StatefulWidget {
  const BookDataPage({Key? key}) : super(key: key);

  @override
  State<BookDataPage> createState() => _BookDataPageState();
}

class _BookDataPageState extends State<BookDataPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Data Buku',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAddDataButton(context),
            const SizedBox(height: 16.0),
            FutureBuilder<List<Book>>(
              future: dbHelper.getBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final books = snapshot.data;

                if (books == null || books.isEmpty) {
                  return const Text('Tidak ada data yang tersedia.');
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (BuildContext context, int index) {
                      final book = books[index];

                      return _buildBookCard(context, book);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk tombol menambahkan data buku
  Widget _buildAddDataButton(BuildContext context) {
    return SizedBox(
      height: 56.0,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const BookAddPage(),
            ),
          )
              .then((result) {
            if (result != null && result) {
              _refreshData(); // Refresh data setelah menambahkan buku baru
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 94, 204,
              255), // Button color (replace 'primary' with 'backgroundColor')
          shadowColor: const Color.fromARGB(255, 94, 204, 255), // Text color
        ),
        child: const Text(
          'Tambah Data',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  // Widget untuk menampilkan kartu buku
  Widget _buildBookCard(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookDetailPage(book: book),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        child: ListTile(
          title: Text(book.title),
          subtitle: Text('Kategori: ${book.category}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => BookEditPage(book: book),
                    ),
                  )
                      .then((result) {
                    if (result != null && result) {
                      _refreshData(); // Refresh data setelah mengedit
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirmed =
                      await _showDeleteConfirmationDialog(context);

                  if (confirmed != null && confirmed) {
                    final result = await dbHelper.deleteBook(book.idBook);
                    if (result > 0) {
                      _refreshData(); // Refresh data setelah menghapus
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  // Menampilkan dialog konfirmasi penghapusan
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Buku'),
          content: const Text('Apakah Anda yakin ingin menghapus buku ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // Metode untuk menyegarkan data
  Future<void> _refreshData() async {
    setState(() {});
  }
}
