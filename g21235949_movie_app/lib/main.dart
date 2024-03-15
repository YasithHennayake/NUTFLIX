import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:g21235949_movie_app/app_content/app_pages/splash_screen.dart';
import 'package:g21235949_movie_app/app_content/app_pages/home_page.dart';
import 'package:g21235949_movie_app/app_content/app_pages/login_page.dart';
import 'package:g21235949_movie_app/app_content/app_pages/sign_up_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NUTFLIX',
      theme: ThemeData(
        brightness: Brightness.dark, // Setting the brightness to dark
      ),
      routes: {
        '/': (context) => SplashScreen(child: LoginPage()), // Show splash screen with login page as the initial route
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
