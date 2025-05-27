import 'package:flutter/material.dart';
import 'package:noted/features/auth/presentation/login_screen.dart';
import 'package:noted/features/auth/presentation/signup_screen.dart';
import 'package:noted/features/auth/utils/auth_guard.dart';
import 'package:noted/features/auth/utils/auth_redirect.dart';
import 'package:noted/features/auth/utils/public_guard.dart';
import 'package:noted/features/home/presentation/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // or '/home' if you have auth state management
      routes: {
        '/': (context) => AuthRedirect(),
        '/login': (context) => PublicGuard(child: LoginScreen()),
        '/signup': (context) => PublicGuard(child: SignupScreen()),
        '/home': (context) => AuthGuard(child: HomeScreen()),
        // Add other screen routes here
      },
      // Optional: If you want to handle unknown routes
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text('Page not found')),
        ),
      ),
    );
  }
}
