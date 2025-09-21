import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';

import 'auth.dart';
import '../../parser/screens/presentation.dart';
import '../../../data/services/auth_service.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(                                       // Modify from here...
      stream: _authService.userChanges,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AuthScreen(); 
        }

        return const ParserScreen();
      },
    );                                                                 // To here.
  }
}