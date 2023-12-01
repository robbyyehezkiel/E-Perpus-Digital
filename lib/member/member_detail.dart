// Import pustaka dan paket yang diperlukan
import 'package:e_perpus_app/data/member.dart';
import 'package:flutter/material.dart';

// Kelas untuk halaman Detail Anggota
class MemberDetailPage extends StatelessWidget {
  // Properti untuk menyimpan data anggota yang akan ditampilkan
  final Member member;

  // Konstruktor untuk menginisialisasi data anggota
  const MemberDetailPage({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Detail Anggota',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Membuat widget TextField untuk menampilkan NIM anggota
            _buildTextField('NIM:', member.nim),
            // Membuat widget TextField untuk menampilkan Nama anggota
            _buildTextField('Nama:', member.name),
            // Membuat widget TextField untuk menampilkan Nomor Handphone anggota
            _buildTextField('Nomor Handphone:', member.handphone),
            // Membuat widget TextField untuk menampilkan Kelas anggota
            _buildTextField('Kelas:', member.classField),
            // Anda dapat menambahkan detail lain sesuai kebutuhan
          ],
        ),
      ),
    );
  }

  // Metode untuk membuat widget TextField dengan label dan nilai tertentu
  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menampilkan label dengan gaya teks tertentu
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        // Membungkus TextField dalam wadah dengan latar belakang abu-abu muda
        Container(
          color: Colors.grey[200],
          // TextField dibuat tidak dapat diubah (readOnly) agar bersifat hanya baca
          child: TextField(
            controller: TextEditingController(text: value),
            readOnly: true,
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
