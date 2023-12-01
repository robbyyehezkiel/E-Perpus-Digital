// Import pustaka dan paket yang diperlukan
import 'package:e_perpus_app/data/worker.dart';
import 'package:e_perpus_app/worker/worker_add.dart';
import 'package:e_perpus_app/worker/worker_detail.dart';
import 'package:e_perpus_app/worker/worker_edit.dart';
import 'package:flutter/material.dart';
import 'package:e_perpus_app/database_helper.dart';

// Kelas untuk halaman Data Pekerja
class WorkerDataPage extends StatefulWidget {
  const WorkerDataPage({Key? key}) : super(key: key);

  @override
  State<WorkerDataPage> createState() => _WorkerDataPageState();
}

// Kelas untuk menangani state pada halaman Data Pekerja
class _WorkerDataPageState extends State<WorkerDataPage> {
  // Instance DatabaseHelper untuk interaksi dengan database
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Data Pekerja',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tombol untuk menambahkan data pekerja
            _buildAddDataButton(context),
            const SizedBox(height: 16.0),
            // FutureBuilder untuk mendapatkan data pekerja dari database
            FutureBuilder<List<Worker>>(
              future: dbHelper.getWorkers(),
              builder: (context, snapshot) {
                // Menampilkan indikator loading jika data sedang diambil
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                // Menampilkan pesan error jika terjadi error
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                // Mendapatkan data pekerja dari snapshot
                final workers = snapshot.data;

                // Menampilkan pesan jika tidak ada data pekerja
                if (workers == null || workers.isEmpty) {
                  return const Text('Tidak ada data yang tersedia.');
                }

                // Menampilkan daftar data pekerja
                return Expanded(
                  child: ListView.builder(
                    itemCount: workers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final worker = workers[index];

                      // Membuat kartu data pekerja
                      return _buildWorkerCard(context, worker);
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

  // Widget untuk membuat tombol tambah data pekerja
  Widget _buildAddDataButton(BuildContext context) {
    return SizedBox(
      height: 56.0,
      child: ElevatedButton(
        onPressed: () {
          // Menavigasi ke halaman WorkerAddPage untuk menambahkan data
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const WorkerAddPage(),
            ),
          )
              .then((result) {
            // Meresfresh data setelah menambahkan pekerja baru
            if (result != null && result) {
              _refreshData();
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

  // Widget untuk membuat kartu data pekerja
  Widget _buildWorkerCard(BuildContext context, Worker worker) {
    return GestureDetector(
      onTap: () {
        // Menavigasi ke halaman WorkerDetailPage untuk melihat detail pekerja
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WorkerDetailPage(worker: worker),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        child: ListTile(
          title: Text(worker.name),
          subtitle: Text('Handphone: ${worker.handphone}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tombol untuk mengedit data pekerja
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Menavigasi ke halaman WorkerEditPage untuk mengedit data
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => WorkerEditPage(worker: worker),
                    ),
                  )
                      .then((result) {
                    // Meresfresh data setelah mengedit pekerja
                    if (result != null && result) {
                      _refreshData();
                    }
                  });
                },
              ),
              // Tombol untuk menghapus data pekerja
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // Menampilkan konfirmasi sebelum menghapus data pekerja
                  final confirmed =
                      await _showDeleteConfirmationDialog(context);

                  if (confirmed != null && confirmed) {
                    // Menghapus data pekerja dan meresfresh data
                    final result = await dbHelper.deleteWorker(worker.nip);
                    if (result > 0) {
                      _refreshData();
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

  // Metode untuk menampilkan dialog konfirmasi penghapusan data pekerja
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Pekerja'),
          content: const Text('Apakah Anda yakin ingin menghapus pekerja ini?'),
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

  // Metode untuk meresfresh data pekerja
  Future<void> _refreshData() async {
    setState(() {});
  }
}
