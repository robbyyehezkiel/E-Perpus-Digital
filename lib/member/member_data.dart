// Import pustaka dan paket yang diperlukan
import 'package:e_perpus_app/data/member.dart';
import 'package:e_perpus_app/member/member_add.dart';
import 'package:e_perpus_app/member/member_detail.dart';
import 'package:e_perpus_app/member/member_edit.dart';
import 'package:flutter/material.dart';
import 'package:e_perpus_app/database_helper.dart';

// Kelas untuk halaman Data Anggota
class MemberDataPage extends StatefulWidget {
  const MemberDataPage({Key? key}) : super(key: key);

  @override
  State<MemberDataPage> createState() => _MemberDataPageState();
}

// State dari halaman Data Anggota
class _MemberDataPageState extends State<MemberDataPage> {
  // Instance dari DatabaseHelper untuk berinteraksi dengan database SQLite
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 204, 255),
        title: const Text(
          'Data Member',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Membuat tombol "Tambah Data" dan memanggil metode _buildAddDataButton
            _buildAddDataButton(context),
            const SizedBox(height: 16.0),
            // Membuat FutureBuilder untuk menampilkan data anggota
            FutureBuilder<List<Member>>(
              future: dbHelper.getMembers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final members = snapshot.data;

                if (members == null || members.isEmpty) {
                  return const Text('No data available.');
                }

                // Membuat daftar anggota menggunakan ListView.builder
                return Expanded(
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (BuildContext context, int index) {
                      final member = members[index];

                      // Membuat kartu anggota menggunakan _buildMemberCard
                      return _buildMemberCard(context, member);
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

  // Metode untuk membuat tombol "Tambah Data"
  Widget _buildAddDataButton(BuildContext context) {
    return SizedBox(
      height: 56.0,
      child: ElevatedButton(
        onPressed: () {
          // Navigasi ke halaman MemberAddPage untuk menambahkan data anggota baru
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const MemberAddPage(),
            ),
          )
              .then((result) {
            if (result != null && result) {
              _refreshData(); // Menjalankan metode _refreshData setelah menambahkan anggota baru
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

  // Metode untuk membuat kartu anggota
  Widget _buildMemberCard(BuildContext context, Member member) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman MemberDetailPage saat kartu anggota ditekan
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MemberDetailPage(member: member),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        child: ListTile(
          title: Text(member.name),
          subtitle: Text('Nim: ${member.handphone}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigasi ke halaman MemberEditPage untuk mengedit data anggota
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => MemberEditPage(member: member),
                    ),
                  )
                      .then((result) {
                    if (result != null && result) {
                      _refreshData(); // Menjalankan metode _refreshData setelah mengedit data
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  // Menampilkan dialog konfirmasi sebelum menghapus anggota
                  final confirmed =
                      await _showDeleteConfirmationDialog(context);

                  if (confirmed != null && confirmed) {
                    // Menghapus anggota dari database setelah konfirmasi
                    final result = await dbHelper.deleteMember(member.nim);
                    if (result > 0) {
                      _refreshData(); // Menjalankan metode _refreshData setelah menghapus data
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

  // Metode untuk menampilkan dialog konfirmasi penghapusan anggota
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Anggota'),
          content: const Text('Apakah Anda yakin ingin menghapus anggota ini?'),
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

  // Metode untuk menyegarkan data di halaman setelah aksi tertentu (tambah, edit, hapus)
  Future<void> _refreshData() async {
    setState(() {});
  }
}
