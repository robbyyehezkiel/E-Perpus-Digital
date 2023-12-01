// Import pustaka dan paket yang diperlukan
import 'package:e_perpus_app/data/member.dart';
import 'package:flutter/material.dart';
import 'package:e_perpus_app/database_helper.dart';

// Kelas untuk halaman Edit Anggota
class MemberEditPage extends StatefulWidget {
  // Properti untuk menyimpan data anggota yang akan diedit
  final Member member;

  // Konstruktor untuk menginisialisasi data anggota yang akan diedit
  const MemberEditPage({Key? key, required this.member}) : super(key: key);

  @override
  _MemberEditPageState createState() => _MemberEditPageState();
}

// Kelas untuk menangani state pada halaman Edit Anggota
class _MemberEditPageState extends State<MemberEditPage> {
  // Controller untuk bidang teks NIM anggota
  final TextEditingController nimController = TextEditingController();
  // Controller untuk bidang teks Nama anggota
  final TextEditingController nameController = TextEditingController();
  // Controller untuk bidang teks Nomor Handphone anggota
  final TextEditingController handphoneController = TextEditingController();
  // Controller untuk bidang teks Kelas anggota
  final TextEditingController classFieldController = TextEditingController();
  // Status untuk menandai apakah data anggota telah dimodifikasi
  bool _isDataModified = false;

  @override
  void initState() {
    super.initState();

    // Menginisialisasi controller dengan data anggota saat ini
    nimController.text = widget.member.nim;
    nameController.text = widget.member.name;
    handphoneController.text = widget.member.handphone;
    classFieldController.text = widget.member.classField;

    // Mendengarkan perubahan pada bidang teks Nama dan Nomor Handphone
    nameController.addListener(_onDataModified);
    handphoneController.addListener(_onDataModified);
  }

  @override
  void dispose() {
    // Membersihkan controller saat widget dihapus
    nameController.dispose();
    handphoneController.dispose();
    super.dispose();
  }

  // Metode untuk menangani perubahan pada bidang teks
  void _onDataModified() {
    // Memeriksa apakah salah satu bidang telah dimodifikasi
    final nameModified = nameController.text != widget.member.name;
    final handphoneModified =
        handphoneController.text != widget.member.handphone;
    final classFieldModified =
        classFieldController.text != widget.member.classField;

    setState(() {
      // Mengupdate status _isDataModified
      _isDataModified = nameModified || handphoneModified || classFieldModified;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Edit Anggota',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bidang teks untuk menampilkan NIM (tidak dapat diubah)
            TextField(
              controller: nimController,
              enabled: false, // Membuat bidang ini hanya dapat dibaca
              decoration: const InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            // Bidang teks untuk mengedit Nama anggota
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            // Bidang teks untuk mengedit Nomor Handphone anggota
            TextField(
              controller: handphoneController,
              decoration: const InputDecoration(
                labelText: 'Nomor Handphone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            // Bidang teks untuk mengedit Kelas anggota
            TextField(
              controller: classFieldController,
              decoration: const InputDecoration(
                labelText: 'Kelas',
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

  // Metode untuk menyimpan perubahan ke dalam database
  Future<void> _saveChanges() async {
    final dbHelper = DatabaseHelper();

    // Membuat objek Member baru dengan data yang diperbarui
    final updatedMember = Member(
      nim: nimController.text,
      name: nameController.text,
      handphone: handphoneController.text,
      classField: classFieldController.text,
    );

    // Memanggil metode updateMember pada dbHelper
    await dbHelper.updateMember(updatedMember);

    // Menutup halaman dan memberi tahu halaman sebelumnya bahwa perubahan berhasil
    Navigator.of(context).pop(true);
  }
}
