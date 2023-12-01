// Import pustaka dan paket yang diperlukan
import 'package:e_perpus_app/data/worker.dart';
import 'package:flutter/material.dart';
import 'package:e_perpus_app/database_helper.dart';

// Kelas untuk halaman edit pekerja
class WorkerEditPage extends StatefulWidget {
  final Worker worker;

  const WorkerEditPage({Key? key, required this.worker}) : super(key: key);

  @override
  _WorkerEditPageState createState() => _WorkerEditPageState();
}

// Kelas state untuk WorkerEditPage
class _WorkerEditPageState extends State<WorkerEditPage> {
  // TextEditingController untuk mengontrol input teks
  final TextEditingController nipController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController handphoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool _isDataModified =
      false; // Menyimpan status apakah data telah diubah atau tidak

  @override
  void initState() {
    super.initState();

    // Menginisialisasi kontroler teks dengan data pekerja saat ini
    nipController.text = widget.worker.nip;
    nameController.text = widget.worker.name;
    handphoneController.text = widget.worker.handphone;
    addressController.text = widget.worker.address;

    // Mendengarkan perubahan dalam kolom teks
    nameController.addListener(_onDataModified);
    handphoneController.addListener(_onDataModified);
    addressController.addListener(_onDataModified);
  }

  @override
  void dispose() {
    // Memastikan untuk membuang kontroler teks setelah widget dihancurkan
    nameController.dispose();
    handphoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Metode yang dipanggil ketika data diubah
  void _onDataModified() {
    // Memeriksa apakah salah satu kolom telah diubah
    final nameModified = nameController.text != widget.worker.name;
    final handphoneModified =
        handphoneController.text != widget.worker.handphone;
    final addressModified = addressController.text != widget.worker.address;

    setState(() {
      _isDataModified = nameModified || handphoneModified || addressModified;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Edit Pekerja',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kolom teks yang menampilkan NIP
            TextField(
              controller: nipController,
              enabled: false, // Membuat kolom ini hanya bisa dibaca
              decoration: const InputDecoration(
                labelText: 'NIP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            // Kolom teks untuk mengedit nama
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            // Kolom teks untuk mengedit nomor handphone
            TextField(
              controller: handphoneController,
              decoration: const InputDecoration(
                labelText: 'Nomor Handphone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            // Kolom teks untuk mengedit alamat
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            // Tombol untuk menyimpan perubahan jika ada
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

    // Membuat objek Worker baru dengan perubahan
    final updatedWorker = Worker(
      nip: nipController.text,
      name: nameController.text,
      handphone: handphoneController.text,
      address: addressController.text,
    );

    // Mengupdate data pekerja di database SQLite
    await dbHelper.updateWorker(updatedWorker);

    // Kembali ke halaman sebelumnya dengan memberi tahu bahwa perubahan telah disimpan
    Navigator.of(context).pop(true);
  }
}
