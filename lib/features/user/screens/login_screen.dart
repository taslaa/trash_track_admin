import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/user/services/auth_service.dart'; // Adjust the import path to your AuthService file
import 'package:trash_track_admin/features/user/widgets/success_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AuthService _authService; // Remove the initialization here

  @override
  void initState() {
    super.initState();
    _authService = AuthService(); // Initialize AuthService in initState
  }

  void _handleSignIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final token = await _authService.signIn(email, password);

    if (token != null) {
      // Login successful, navigate to the SuccessScreen for testing.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );
    } else {
      // Login failed, show an error message to the user.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid email or password. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleSignIn,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
