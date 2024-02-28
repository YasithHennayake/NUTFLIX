import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g21235949_movie_app/app_content/app_pages/splash_screen.dart';
import 'package:g21235949_movie_app/app_content/app_pages/home_page.dart';
import 'package:g21235949_movie_app/app_content/app_pages/login_page.dart';
import 'package:g21235949_movie_app/app_content/app_pages/sign_up_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDVu7C0g3VjQO43u1flaeHHOKOxAxBocdA",
          appId: "1:954112658260:web:23d870c8b1c912e5b596c1",
          messagingSenderId: "954112658260",
          projectId: "nutflix-b4527"
          // web Firebase config options
          ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NUTFLIX',
      routes: {
        '/': (context) => SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
