import 'package:flutter/material.dart';
import 'package:g21235949_movie_app/app_features/user_related_features/appearance/app_widgets/form_container_widget.dart';
import 'package:g21235949_movie_app/app_features/user_related_features/appearance/pages/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _signUp() async {
    setState(() {
      _isSigningUp = true;
    });

    // TODO: Implement your sign-up logic here
    // Example: await signUpWithEmailAndPassword(_emailController.text, _passwordController.text, _usernameController.text);

    // Simulating a network request delay for demonstration purposes
    await Future.delayed(
        Duration(seconds: 2)); // Remove this in your actual implementation

    setState(() {
      _isSigningUp = false;
    });

    // Navigate to HomePage or login page upon successful sign-up
    // This should be inside your actual sign-up logic success callback
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
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              FormContainerWidget(
                  controller: _emailController,
                  hintText: "Email",
                  isPasswordField: false),
              const SizedBox(height: 10),
              FormContainerWidget(
                  controller: _passwordController,
                  hintText: "Password",
                  isPasswordField: true),
              const SizedBox(height: 10),
              FormContainerWidget(
                  controller: _usernameController,
                  hintText: "Username",
                  isPasswordField: false),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _isSigningUp ? null : _signUp,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigningUp
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign Up to NUTFLIX",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Text("Login",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
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
