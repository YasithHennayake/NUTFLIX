//imported packages
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../app_widgets/form_container_widget.dart';
import 'sign_up_page.dart';
import '../app_services/firebase_auth_services.dart';
import '../app_widgets/email_toast_widget.dart';

// Login Page Widget
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

// State class for the Login Page
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigningIn = false;
  bool _isOnline = true; // To track internet connectivity
  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  // Connectivity subscription
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    // Initialize the connectivity subscription
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Method to update internet connectivity status
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _isOnline = result != ConnectivityResult.none;
    });
    if (!_isOnline) {
      showToast(
          message:
              "No internet connection. Please check your network settings.");
    }
  }

  // Method to handle the sign-in process
  Future<void> _signIn() async {
    if (!_isOnline) {
      // Check internet connection before attempting sign-in
      showToast(
          message:
              "No internet connection. Please check your network settings.");
      return;
    }

    setState(() {
      _isSigningIn = true;
    });

    var user = await _authServices.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user != null) {
      // Show success message and navigate to home page if sign-in successful
      showToast(message: "User is successfully signed in");
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      // Show error message if sign-in failed
      showToast(message: "Failed to sign in. Please check your credentials.");
    }

    setState(() {
      _isSigningIn = false;
    });
  }

  @override
  void dispose() {
    // Dispose controllers and subscription when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("NUTFLIX"),
        titleTextStyle: const TextStyle(
            color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 36),
              // Email input field
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(height: 12),
              // Password input field
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(height: 24),
              // Login Button
              ElevatedButton(
                onPressed: _isSigningIn ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSigningIn
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
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
