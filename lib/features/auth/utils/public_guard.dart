import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PublicGuard extends StatelessWidget {
  final Widget child;

  const PublicGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Já está logado, redireciona para a Home
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/home');
      });

      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return child; // Ainda não logado, pode ver a tela
  }
}
