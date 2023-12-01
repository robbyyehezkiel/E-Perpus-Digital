import 'package:e_perpus_app/database_helper.dart';
import 'package:e_perpus_app/non_auth/login_page.dart';
import 'package:e_perpus_app/non_auth/registration_page.dart';
import 'package:e_perpus_app/non_auth/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseHelper = DatabaseHelper();
  await databaseHelper.seedMembers();
  await databaseHelper.seedBook();
  await databaseHelper.seedWorkers();
  await databaseHelper.seedEmail();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Authentication App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
