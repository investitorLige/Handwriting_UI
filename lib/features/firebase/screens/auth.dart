import 'package:flutter/material.dart';

import 'package:handwriting_ui/data/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLogin = true;
  String _email = '';
  String _password = '';

  void _trySubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      
      if (_isLogin) {
        // Log in
        _authService
          .emailSignIn(_email, _password)
          .then((userCredential) {
            if (userCredential == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login failed. Please try again.')),
              );
            }
          });
      } else {
        // Sign up
        _authService
          .emailSignUp(_email, _password)
          .then((userCredential) {
            if (userCredential == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up failed. Please try again.')),
              );
            }
          });
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
      ),
      body: Stack(
        children: [ 
          Stack(
            children: [
              SizedBox.expand(
                child: Image.asset(
                  '/images/propaganda/ji.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ]
          ),
          Center(
            child: Card(
              color: Colors.transparent,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        key: const ValueKey('email'),
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const ValueKey('password'),
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'I already have an account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      )]
      ),
    );
  }
}