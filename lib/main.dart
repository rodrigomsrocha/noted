import 'package:flutter/material.dart';
import 'package:noted/features/auth/presentation/login_screen.dart';
import 'package:noted/features/auth/presentation/signup_screen.dart';
import 'package:noted/features/home/presentation/home_screen.dart';
// import other screens as needed

void main() {
  runApp(MyApp());
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
      initialRoute: '/login', // or '/home' if you have auth state management
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => const HomeScreen(),
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
