import 'package:flutter/material.dart';
import 'package:g21235949_movie_app/app_features/user_related_features/appearance/app_widgets/form_container_widget.dart';
import 'package:g21235949_movie_app/app_features/user_related_features/appearance/pages/home_page.dart';
import 'package:g21235949_movie_app/app_features/user_related_features/appearance/pages/sign_up_page.dart'; // Adjust this import according to your file structure

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    setState(() {
      _isSigningIn = true;
    });

    // TODO: Implement your sign-in logic here
    // Example: await signInWithEmailAndPassword(_emailController.text, _passwordController.text);

    // This is just a placeholder for delay simulation, replace it with your authentication logic
    await Future.delayed(const Duration(seconds: 2));

    // After sign-in logic
    setState(() {
      _isSigningIn = false;
    });

    // Navigate to the HomePage or show an error message
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
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
                "Login",
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
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _isSigningIn ? null : _signIn,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigningIn
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login to NUTFLIX",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SignUpPage())); // Adjust this according to your project
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
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
