//imported packages
import 'package:flutter/material.dart';
import '../app_widgets/form_container_widget.dart';
import 'login_page.dart';
import '../app_services/firebase_auth_services.dart';
import '../app_widgets/email_toast_widget.dart';

// Sign-up Page Widget
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// State class for the Sign-up Page
class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthServices _authServices = FirebaseAuthServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isSigningUp = false; // To track the sign-up process

  @override
  // Dispose controllers when the widget is disposed
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // Method to handle the sign-up process
  Future<void> _signUp() async {
    setState(() {
      _isSigningUp = true;
    });

    var user = await _authServices.signUpWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user != null) {
      // Show success message and navigate to home page if sign-up successful
      showToast(message: 'Sign-up successful');
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      // Show error message if sign-up failed
      showToast(message: 'Sign-up failed. Please try again.');
    }

    setState(() {
      _isSigningUp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("NUTFLIX"),
        titleTextStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              // Email input field
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(height: 10),
              // Password input field
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(height: 10),
              // Username input field
              FormContainerWidget(
                controller: _usernameController,
                hintText: "Username",
                isPasswordField: false,
              ),
              const SizedBox(height: 30),
              // Sign-up Button
              ElevatedButton(
                onPressed: _isSigningUp ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSigningUp
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Sign Up to NUTFLIX",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 20),
              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
