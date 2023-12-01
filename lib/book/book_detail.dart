import 'package:flutter/material.dart';
import 'package:e_perpus_app/data/book.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Detail Buku',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('ID Buku:', book.idBook),
            _buildTextField('Judul:', book.title),
            _buildTextField('Kategori:', book.category),
            // Tambahkan detail lain sesuai kebutuhan
          ],
        ),
      ),
    );
  }

  // Metode untuk membuat widget TextField dengan label dan nilai
  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Container(
          color: Colors.grey[200], // Warna latar belakang abu-abu terang
          child: TextField(
            controller: TextEditingController(text: value),
            readOnly: true, // Membuatnya tidak dapat diubah
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
