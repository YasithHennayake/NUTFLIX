// Imported packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Imported pages
import 'package:g21235949_movie_app/app_content/app_pages/splash_screen.dart';
import 'package:g21235949_movie_app/app_content/app_pages/home_page.dart';
import 'package:g21235949_movie_app/app_content/app_pages/login_page.dart';
import 'package:g21235949_movie_app/app_content/app_pages/sign_up_page.dart';
import 'firebase_options.dart';

void main() async {
  // Initializing flutter buindings
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase with default option
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

// Main application class
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NUTFLIX', // app title
      routes: {
        '/': (context) => SplashScreen(
              // Displaying the SplashScreen with LoginPage as child
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(), // Route for Login Page
        '/signUp': (context) => SignUpPage(), // Route for Sign Up Page
        '/home': (context) => HomePage(), // Route for Home Page
      },
    );
  }
}
