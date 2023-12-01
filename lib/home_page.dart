import 'package:flutter/material.dart';
import 'package:e_perpus_app/book/book_data.dart';
import 'package:e_perpus_app/member/member_data.dart';
import 'package:e_perpus_app/non_auth/login_page.dart';
import 'package:e_perpus_app/order/order_add.dart';
import 'package:e_perpus_app/order/order_data.dart';
import 'package:e_perpus_app/data/user.dart';
import 'package:e_perpus_app/worker/worker_data.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);
  void _logout(BuildContext context) {
    _showSignOutConfirmationDialog(context);
  }

  void _navigateToPage(BuildContext context, int index) {
    final List<Widget> pages = [
      const WorkerDataPage(),
      const MemberDataPage(),
      const OrderDataPage(),
      const BookDataPage(),
    ];

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => pages[index],
      ),
    );
  }

  Future<void> _showSignOutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Sign Out'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sign Out successful!'),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.green,
                  ),
                );
                SessionManager().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage()), // Navigate to the login page after logout
                  (route) => false, // Remove all previous routes from the stack
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange, // Set the background color to orange
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 94, 204, 255),
          automaticallyImplyLeading: false,
          title: const Text(
            'Home Page',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () => _logout(context), // Call the logout function
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 220 + 50.0, // Image height + 50 pixels
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/eperpus.png',
                          width: 220,
                          height: 220,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Container(
                  color: const Color.fromARGB(255, 94, 204, 255),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 56.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddOrderPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .white, // Button color (replace 'primary' with 'backgroundColor')
                                  shadowColor: const Color.fromARGB(
                                      255, 94, 204, 255), // Text color
                                ),
                                child: const Text(
                                  'Tambah Data',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Expanded(child: _buildGrid(context)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final List<IconData> icons = [
      Icons.work, // Pencil icon
      Icons.person, // Close icon
      Icons.post_add, // Add icon
      Icons.my_library_books, // Eye icon
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns per row
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: 4, // Number of items
      itemBuilder: (context, index) {
        return _buildListCard(context, icons[index], index);
      },
    );
  }

  Widget _buildListCard(BuildContext context, IconData icon, int index) {
    final List<String> titles = [
      'Data Pegawai',
      'Data Anggota',
      'Data Peminjaman',
      'Data Buku',
    ];

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(0.0), // Removed margin
      child: InkWell(
        onTap: () => _navigateToPage(context, index),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 48.0, color: Colors.blue), // Set icon with a blue color
              const SizedBox(height: 8.0), // Add spacing between icon and text
              Text(
                titles[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
