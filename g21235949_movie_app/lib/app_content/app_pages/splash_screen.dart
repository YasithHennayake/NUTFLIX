//imported packages
import 'package:flutter/material.dart';

// SplashScreen widget to display a splash screen with a delay before navigating to another screen
class SplashScreen extends StatefulWidget {
  final Widget? child; // Child widget to navigate to after the splash screen
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Delayed navigation to the child widget after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  widget.child!), // Navigate to the child widget
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold containing the splash screen text
    return Scaffold(
      body: Center(
        child: Text(
          "WELCOME TO NUTFLIX",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
