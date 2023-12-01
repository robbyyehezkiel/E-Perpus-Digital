// Import pustaka dan paket yang diperlukan
import 'package:e_perpus_app/data/worker.dart';
import 'package:e_perpus_app/database_helper.dart';
import 'package:e_perpus_app/worker/worker_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Kelas untuk halaman Tambah Data Pekerja
class WorkerAddPage extends StatefulWidget {
  const WorkerAddPage({Key? key}) : super(key: key);

  @override
  _WorkerAddPageState createState() => _WorkerAddPageState();
}

// Kelas untuk menangani state pada halaman Tambah Data Pekerja
class _WorkerAddPageState extends State<WorkerAddPage> {
  // Controller untuk bidang teks NIP pekerja
  late TextEditingController nipController;
  // Controller untuk bidang teks Nama pekerja
  late TextEditingController nameController;
  // Controller untuk bidang teks Nomor Handphone pekerja
  late TextEditingController handphoneController;
  // Controller untuk bidang teks Alamat pekerja
  late TextEditingController addressController;

  // Status untuk menandai apakah data sedang ditambahkan
  bool _isAddingData = false;
  // Status untuk menandai apakah NIP valid
  bool _isNipValid = false;

  @override
  void initState() {
    super.initState();
    // Menginisialisasi controller
    nipController = TextEditingController();
    nameController = TextEditingController();
    handphoneController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    // Membersihkan controller saat widget dihapus
    nameController.dispose();
    nipController.dispose();
    handphoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Tambah Data Pekerja',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bidang teks untuk mengisi NIP (tidak boleh kosong)
            _buildTextField(nipController, 'NIP', TextInputType.text),
            const SizedBox(height: 8.0),
            // Bidang teks untuk mengisi Nama pekerja
            _buildTextField(nameController, 'Nama', TextInputType.text),
            const SizedBox(height: 8.0),
            // Bidang teks untuk mengisi Nomor Handphone pekerja
            _buildTextField(
                handphoneController, 'Nomor Handphone', TextInputType.text),
            const SizedBox(height: 8.0),
            // Bidang teks untuk mengisi Alamat pekerja
            _buildTextField(addressController, 'Alamat', TextInputType.text),
            const SizedBox(height: 8.0),
            // Tombol untuk menambahkan data pekerja
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat bidang teks
  Widget _buildTextField(
      TextEditingController controller, String label, TextInputType inputType) {
    String? errorText;
    // Menetapkan pesan kesalahan khusus untuk NIP
    if (label == 'NIP') {
      errorText = _isNipValid ? null : 'NIP tidak boleh kosong';
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
      onChanged: (value) {
        setState(() {
          if (label == 'NIP') {
            _isNipValid = value.isNotEmpty;
          }
        });
      },
      keyboardType: inputType,
    );
  }

  // Widget untuk membuat tombol untuk menambahkan data pekerja
  Widget _buildAddButton() {
    return SizedBox(
      height: 56.0,
      child: ElevatedButton(
        onPressed: (_isAddingData || !_isNipValid) ? null : addWorkerData,
        child: _isAddingData
            ? const CircularProgressIndicator()
            : const Text('Tambah Data Pekerja'),
      ),
    );
  }

  // Metode untuk menambahkan data pekerja ke dalam database
  Future<void> addWorkerData() async {
    final name = nameController.text;
    final nip = nipController.text;
    final handphone = handphoneController.text;
    final address = addressController.text;

    // Memeriksa apakah NIP kosong
    if (nip.isEmpty) {
      _showSnackBar('NIP tidak boleh kosong.');
      return;
    }

    // Memeriksa apakah NIP sudah ada di dalam koleksi
    final dbHelper = DatabaseHelper();
    final duplicateNip = await dbHelper.isDuplicateNipWorker(nip);

    // Menampilkan pesan jika NIP sudah ada
    if (duplicateNip) {
      _showSnackBar('NIP ini sudah ada dalam koleksi.');
      return;
    }

    setState(() {
      _isAddingData = true;
    });

    // Membuat objek Worker baru
    final worker = Worker(
      nip: nip,
      name: name,
      handphone: handphone,
      address: address,
    );

    final db = await dbHelper.database;

    try {
      // Memulai transaksi database untuk menambahkan data pekerja
      await db!.transaction((txn) async {
        await txn.insert('Workers', worker.toMap());
      });

      // Menampilkan dialog sukses setelah menambahkan data pekerja
      _showSuccessDialog();
    } catch (e) {
      // Menampilkan pesan kesalahan jika terjadi error
      _showSnackBar('Error menambahkan data pekerja: $e');
      if (kDebugMode) {
        print('Error menambahkan data pekerja: $e');
      }
    } finally {
      // Mengakhiri proses penambahan data dan mengubah status
      setState(() {
        _isAddingData = false;
      });
    }
  }

  // Metode untuk menampilkan Snackbar dengan pesan tertentu
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Metode untuk menampilkan dialog sukses setelah menambahkan data pekerja
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Data Ditambahkan dengan Sukses'),
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
              child: const Text('Menuju Data Pekerja'),
              onPressed: () {
                Navigator.of(context).pop();
                navigateToWorkerDataPage();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    nipController.clear();
    nameController.clear();
    handphoneController.clear();
    addressController.clear();

    // Reset validation status
    setState(() {
      _isNipValid = false;
    });
  }

  // Metode untuk pindah ke halaman Data Pekerja setelah menambahkan data
  void navigateToWorkerDataPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const WorkerDataPage(),
      ),
    );
  }
}
