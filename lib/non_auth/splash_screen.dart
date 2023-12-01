// Import library yang dibutuhkan dari Flutter
import 'package:flutter/material.dart';

// Import halaman utama (HomePage) dan data pengguna (User)
import 'package:e_perpus_app/home_page.dart';
import 'package:e_perpus_app/data/user.dart';

// Import halaman login (LoginPage)
import 'package:e_perpus_app/non_auth/login_page.dart';

// Kelas SplashScreen yang merupakan StatefulWidget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  // Override createState untuk membuat instance dari _SplashScreenState
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// Kelas state untuk SplashScreen
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil metode _checkUserLoggedIn saat inisialisasi state
    _checkUserLoggedIn();
  }

  // Metode untuk memeriksa apakah pengguna sudah login
  void _checkUserLoggedIn() {
    // Lakukan pemeriksaan setelah jeda singkat untuk memastikan proses build sudah selesai
    Future.delayed(const Duration(seconds: 2), () {
      // Ambil instance User dari SessionManager
      final User? user = SessionManager().currentUser;
      // Panggil metode _navigateToPage dengan instance User sebagai parameter
      _navigateToPage(user);
    });
  }

  // Metode untuk melakukan navigasi ke halaman yang sesuai berdasarkan status login pengguna
  void _navigateToPage(User? user) {
    if (user != null) {
      // Jika pengguna sudah login, navigasi ke HomePage dengan membawa instance User
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(user: user),
        ),
      );
    } else {
      // Jika pengguna belum login, navigasi ke LoginPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  // Override metode build untuk membangun UI SplashScreen
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Scaffold dengan body berisi CircularProgressIndicator di tengah layar
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
