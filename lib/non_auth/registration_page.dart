import 'package:flutter/material.dart';
import 'package:e_perpus_app/data/user.dart';
import 'package:e_perpus_app/non_auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordInvalid = false;
  bool isEmailInvalid = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isEmailValid(String email) {
    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  void _registerUser() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.length < 5 || !isEmailValid(email)) {
      setState(() {
        isPasswordInvalid = password.length < 5;
        isEmailInvalid = email.isEmpty || !isEmailValid(email);
      });
      return;
    }

    final userRepository = UserRepository();

    // Check if the user already exists with the given email
    final userExists = await userRepository.doesUserExist(email);

    if (!userExists) {
      // User does not exist, proceed with registration
      final user = User(email: email, password: password);
      final userId = await userRepository.insertUser(user);

      if (userId > 0) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the login screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Handle the case where insertion into the database failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // User with the same email already exists
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User with the same email already exists.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 94, 204, 255),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'E-PERPUS DIGITAL \nPELITA RAYA SCHOOL',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/gambar_pelita.png',
                        width: 220,
                        height: 220,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        errorText: isEmailInvalid
                            ? 'Invalid email format or cannot be empty'
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          isPasswordInvalid = value.length < 5;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        errorText:
                            isPasswordInvalid ? 'Password is too short' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 56.0,
                    child: ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        textStyle: const TextStyle(fontSize: 18),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Register'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
