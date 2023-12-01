// Import pustaka dan paket yang diperlukan
import 'package:e_perpus_app/data/member.dart';
import 'package:e_perpus_app/member/member_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_perpus_app/database_helper.dart'; // Import DatabaseHelper

// Kelas untuk halaman penambahan data anggota
class MemberAddPage extends StatefulWidget {
  const MemberAddPage({Key? key}) : super(key: key);

  @override
  _MemberAddPageState createState() => _MemberAddPageState();
}

// State dari halaman penambahan data anggota
class _MemberAddPageState extends State<MemberAddPage> {
  // Controller untuk mengelola input teks
  late TextEditingController nimController;
  late TextEditingController nameController;
  late TextEditingController handphoneController;
  late TextEditingController classFieldController;

  // Status untuk memantau proses penambahan data
  bool _isAddingData = false;
  bool _isNimValid = false; // Menyimpan kevalidan NIM

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller teks
    nimController = TextEditingController();
    nameController = TextEditingController();
    handphoneController = TextEditingController();
    classFieldController = TextEditingController();
  }

  @override
  void dispose() {
    // Membersihkan controller teks untuk mencegah memory leak
    nameController.dispose();
    nimController.dispose();
    handphoneController.dispose();
    classFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Tambah Data Anggota',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Memanggil metode untuk membuat input NIM
            _buildTextField(nimController, 'NIM', TextInputType.number),
            const SizedBox(height: 8.0),
            // Memanggil metode untuk membuat input nama
            _buildTextField(nameController, 'Nama', TextInputType.text),
            const SizedBox(height: 8.0),
            // Memanggil metode untuk membuat input nomor handphone
            _buildTextField(
                handphoneController, 'Nomor Handphone', TextInputType.text),
            const SizedBox(height: 8.0),
            // Memanggil metode untuk membuat input kelas
            _buildTextField(classFieldController, 'Kelas', TextInputType.text),
            const SizedBox(height: 8.0),
            // Memanggil metode untuk membuat tombol "Tambah Data Anggota"
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  // Metode untuk membuat input teks dengan label dan validasi khusus
  Widget _buildTextField(
      TextEditingController controller, String label, TextInputType inputType) {
    String? errorText;
    // Menetapkan pesan kesalahan khusus untuk NIM
    if (label == 'NIM') {
      errorText = _isNimValid ? null : 'NIM harus tepat 5 digit';
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
      onChanged: (value) {
        // Memanggil metode untuk memperbarui kevalidan NIM
        setState(() {
          if (label == 'NIM') {
            _isNimValid = _isNumeric(value) && value.length == 5;
          }
        });
      },
      keyboardType: inputType,
    );
  }

  // Metode untuk membuat tombol "Tambah Data Anggota"
  Widget _buildAddButton() {
    return SizedBox(
      height: 56.0,
      child: ElevatedButton(
        onPressed: (_isAddingData || !_isNimValid) ? null : addMemberData,
        child: _isAddingData
            ? const CircularProgressIndicator()
            : const Text('Tambah Data Anggota'),
      ),
    );
  }

  // Metode untuk menambahkan data anggota ke database
  Future<void> addMemberData() async {
    final name = nameController.text;
    final nim = nimController.text;
    final handphone = handphoneController.text;
    final classField = classFieldController.text;

    // Validasi NIM
    if (!_isNumeric(nim)) {
      _showSnackBar('NIM harus berupa nilai numerik.');
      return;
    }

    if (nim.length != 5) {
      _showSnackBar('NIM harus tepat 5 digit.');
      return;
    }

    final dbHelper = DatabaseHelper();
    final duplicateId = await dbHelper.isDuplicateMemberId(nim);

    // Validasi NIM unik
    if (duplicateId) {
      _showSnackBar('NIM ini sudah ada dalam koleksi.');
      return;
    }

    setState(() {
      _isAddingData = true;
    });

    // Membuat objek anggota
    final member = Member(
      name: name,
      nim: nim,
      handphone: handphone,
      classField: classField,
    );

    // Mendapatkan instance database
    final db = await dbHelper.database;

    try {
      await db!.transaction((txn) async {
        await txn.insert('Members', member.toMap());
      });

      // Menampilkan dialog sukses setelah penambahan data
      _showSuccessDialog();
    } catch (e) {
      // Menampilkan pesan kesalahan jika terjadi error
      _showSnackBar('Error menambahkan data anggota: $e');
      if (kDebugMode) {
        print('Error menambahkan data anggota: $e');
      }
    } finally {
      setState(() {
        _isAddingData = false;
      });
    }
  }

  // Metode untuk mengecek apakah sebuah nilai dapat diubah menjadi tipe numerik
  bool _isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  // Metode untuk menampilkan snackbar dengan pesan tertentu
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Data Berhasil Ditambahkan'),
          content: const Text('Apa yang ingin Anda lakukan selanjutnya?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tambah Data Lainnya'),
              onPressed: () {
                _resetForm(); // Call the reset method
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Pergi ke Data Anggota'),
              onPressed: () {
                // Navigasi ke halaman Data Anggota setelah penambahan data
                Navigator.of(context).pop();
                navigateToMemberDataPage();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to reset form inputs
  void _resetForm() {
    nimController.clear();
    nameController.clear();
    handphoneController.clear();
    classFieldController.clear();

    // Reset validation status
    setState(() {
      _isNimValid = false;
    });
  }

  // Metode untuk berpindah ke halaman Data Anggota
  void navigateToMemberDataPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MemberDataPage(),
      ),
    );
  }
}
