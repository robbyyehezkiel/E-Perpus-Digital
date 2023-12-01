import 'package:flutter/material.dart';
import 'package:e_perpus_app/data/book.dart';
import 'package:e_perpus_app/database_helper.dart';

class BookEditPage extends StatefulWidget {
  final Book book;

  const BookEditPage({Key? key, required this.book}) : super(key: key);

  @override
  _BookEditPageState createState() => _BookEditPageState();
}

class _BookEditPageState extends State<BookEditPage> {
  // Controller untuk mengelola input teks
  final TextEditingController idBookController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  bool _isDataModified = false; // Menunjukkan apakah data telah diubah

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller teks dengan data buku saat ini
    idBookController.text = widget.book.idBook;
    titleController.text = widget.book.title;
    categoryController.text = widget.book.category;

    // Dengarkan perubahan di bidang teks
    titleController.addListener(_onDataModified);
    categoryController.addListener(_onDataModified);
  }

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void _onDataModified() {
    // Periksa apakah salah satu bidang telah diubah
    final titleModified = titleController.text != widget.book.title;
    final categoryModified = categoryController.text != widget.book.category;

    setState(() {
      _isDataModified = titleModified || categoryModified;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Edit Buku',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: idBookController,
              enabled: false, // Membuat bidang ini hanya bisa dibaca
              decoration: const InputDecoration(
                labelText: 'ID Buku',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 56.0,
              child: ElevatedButton(
                onPressed: _isDataModified ? () => _saveChanges() : null,
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Metode untuk menyimpan perubahan ke database
  Future<void> _saveChanges() async {
    final dbHelper = DatabaseHelper();

    // Perbarui data buku di database SQLite
    final updatedBook = Book(
      idBook: idBookController.text,
      title: titleController.text,
      category: categoryController.text,
    );

    await dbHelper.updateBook(updatedBook);

    Navigator.of(context).pop(true); // Indikasikan keberhasilan
  }
}
