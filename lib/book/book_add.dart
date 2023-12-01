// Import statement
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_perpus_app/book/book_data.dart';
import 'package:e_perpus_app/data/book.dart';
import 'package:e_perpus_app/database_helper.dart'; // Import DatabaseHelper

// Kelas untuk menambahkan buku baru
class BookAddPage extends StatefulWidget {
  const BookAddPage({Key? key}) : super(key: key);

  @override
  _BookAddPageState createState() => _BookAddPageState();
}

// Kelas state untuk menangani state dari halaman penambahan buku
class _BookAddPageState extends State<BookAddPage> {
  // Controller untuk mengelola input teks
  late TextEditingController idBookController;
  late TextEditingController titleController;
  late TextEditingController categoryController;

  // Flag untuk melacak status halaman
  bool _isAddingData =
      false; // Menunjukkan jika penambahan data sedang berlangsung
  bool _isIdBookValid = false; // Melacak validitas ID buku yang dimasukkan

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller teks
    idBookController = TextEditingController();
    titleController = TextEditingController();
    categoryController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controller teks ketika widget dihapus
    titleController.dispose();
    idBookController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Membangun antarmuka pengguna untuk halaman penambahan buku
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Tambah Data Buku',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(idBookController, 'ID Buku',
                TextInputType.number), // Bidang input ID Buku
            const SizedBox(height: 8.0),
            _buildTextField(titleController, 'Judul',
                TextInputType.text), // Bidang input Judul
            const SizedBox(height: 8.0),
            _buildTextField(categoryController, 'Kategori',
                TextInputType.text), // Bidang input Kategori
            const SizedBox(height: 8.0),
            _buildAddButton(), // Tombol untuk menambahkan data buku
          ],
        ),
      ),
    );
  }

  // Metode bantu untuk membuat bidang input teks
  Widget _buildTextField(
      TextEditingController controller, String label, TextInputType inputType) {
    String? errorText;
    // Jika label adalah 'ID Buku', periksa validitas ID
    if (label == 'ID Buku') {
      errorText = _isIdBookValid
          ? null
          : 'ID Buku harus terdiri dari 5 digit'; // Pesan kesalahan
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label, // Label untuk bidang input
        border: const OutlineInputBorder(),
        errorText: errorText, // Menampilkan teks kesalahan jika ada
      ),
      onChanged: (value) {
        // Saat input berubah, validasi ID jika itu ID Buku
        setState(() {
          if (label == 'ID Buku') {
            _isIdBookValid = _isNumeric(value) && value.length == 5;
          }
        });
      },
      keyboardType: inputType, // Menetapkan jenis keyboard
    );
  }

  // Metode bantu untuk membuat tombol untuk menambahkan data buku
  Widget _buildAddButton() {
    return SizedBox(
      height: 56.0,
      child: ElevatedButton(
        onPressed: (_isAddingData || !_isIdBookValid)
            ? null
            : addBookData, // Menonaktifkan tombol jika penambahan data sedang berlangsung atau ID tidak valid
        child: _isAddingData
            ? const CircularProgressIndicator()
            : const Text(
                'Tambah Data Buku'), // Menampilkan teks atau indikator loading
      ),
    );
  }

  // Metode untuk menambahkan data buku ke database
  Future<void> addBookData() async {
    final idBook = idBookController.text;
    final title = titleController.text;
    final category = categoryController.text;

    // Validasi input ID Buku
    if (!_isNumeric(idBook)) {
      _showSnackBar(
          'ID Buku harus berupa nilai numerik.'); // Menampilkan pesan kesalahan
      return;
    }

    if (idBook.length != 5) {
      _showSnackBar(
          'ID Buku harus terdiri dari 5 digit.'); // Menampilkan pesan kesalahan
      return;
    }

    // Periksa duplikasi ID di database
    final dbHelper = DatabaseHelper();
    final duplicateId = await dbHelper.isDuplicateId(idBook);

    if (duplicateId) {
      _showSnackBar(
          'ID Buku ini sudah ada dalam koleksi.'); // Menampilkan pesan kesalahan
      return;
    }

    setState(() {
      _isAddingData =
          true; // Mengatur flag untuk menunjukkan penambahan data sedang berlangsung
    });

    final book = Book(
      title: title,
      idBook: idBook,
      category: category,
    );

    final db = await dbHelper.database;

    try {
      // Gunakan transaksi untuk memastikan integritas data
      await db!.transaction((txn) async {
        await txn.insert('Books', book.toMap());
      });

      _showSuccessDialog(); // Menampilkan dialog sukses
    } catch (e) {
      // Menangani kesalahan selama penambahan data
      _showSnackBar('Error menambahkan data buku: $e');
      if (kDebugMode) {
        print('Error menambahkan data buku: $e');
      }
    } finally {
      setState(() {
        _isAddingData = false; // Mengatur ulang flag penambahan data
      });
    }
  }

  // Metode bantu untuk memeriksa apakah sebuah string adalah numerik
  bool _isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  // Metode bantu untuk menampilkan snackbar dengan pesan tertentu
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Metode bantu untuk menampilkan dialog sukses setelah menambahkan data
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Data Ditambahkan dengan Sukses'),
          content: const Text('Apa yang ingin Anda lakukan selanjutnya?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tambahkan Data Lainnya'),
              onPressed: () {
                _resetForm(); // Call the reset method
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Pergi ke Data Buku'),
              onPressed: () {
                Navigator.of(context).pop();
                navigateToBookDataPage();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    idBookController.clear();
    titleController.clear();
    categoryController.clear();
    setState(() {
      _isIdBookValid = false;
    });
  }

  // Metode bantu untuk berpindah ke halaman Data Buku
  void navigateToBookDataPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const BookDataPage(),
      ),
    );
  }
}
