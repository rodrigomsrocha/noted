import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noted/features/home/presentation/home_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Usuário não autenticado -> redireciona para login
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });

      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Usuário autenticado -> pode acessar a tela protegida
    return child;
  }
}
