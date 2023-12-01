// Import pustaka dan paket yang diperlukan
import 'package:e_perpus_app/data/worker.dart';
import 'package:flutter/material.dart';

// Kelas untuk halaman detail pekerja
class WorkerDetailPage extends StatelessWidget {
  final Worker worker;

  const WorkerDetailPage({Key? key, required this.worker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Detail Pekerja',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan detail pekerja menggunakan metode _buildTextField
            _buildTextField('NIP:', worker.nip),
            _buildTextField('Nama:', worker.name),
            _buildTextField('Handphone:', worker.handphone),
            _buildTextField('Alamat:', worker.address),
            // Tambahkan detail lain sesuai kebutuhan
          ],
        ),
      ),
    );
  }

  // Metode untuk membuat widget TextField untuk menampilkan detail pekerja
  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menampilkan label detail dengan gaya tertentu
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        // Container dengan latar belakang abu-abu muda sebagai latar belakang
        Container(
          color: Colors.grey[200],
          child: TextField(
            // Menggunakan TextEditingController untuk menampilkan nilai
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
