import 'package:collab3/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _linkedInController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _githubController,
                decoration: InputDecoration(
                  labelText: 'Github Link',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _linkedInController,
                decoration: InputDecoration(
                  labelText: 'LinkedIn Link',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _reEnterPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Re-enter Password',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  String firstName = _firstNameController.text;
                  String lastName = _lastNameController.text;
                  String email = _emailController.text.trim();
                  String githubLink = _githubController.text;
                  String linkedInLink = _linkedInController.text;
                  String password = _passwordController.text;
                  String reEnterPassword = _reEnterPasswordController.text;

                  // Validate input fields
                  if (firstName.isEmpty ||
                      lastName.isEmpty ||
                      email.isEmpty ||
                      githubLink.isEmpty ||
                      linkedInLink.isEmpty ||
                      password.isEmpty ||
                      reEnterPassword.isEmpty) {
                    _showErrorDialog('Please fill in all fields.');
                    return;
                  }

                  if (password != reEnterPassword) {
                    _showErrorDialog('Passwords do not match.');
                    return;
                  }

                  try {
                    // Create user with email and password
                    UserCredential userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // User creation was successful
                    User? user = userCredential.user;
                    if (user != null) {
                      // Add user details to Firestore
                      await addUserDetails(firstName, lastName, githubLink, linkedInLink, email, password);

                      // Navigate to home screen after successful sign-up
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else {
                      // Handle case where user is null
                      _showErrorDialog('User creation failed.');
                    }
                  } catch (error) {
                    // Handle sign-up errors
                    _showErrorDialog('User creation failed: $error');
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to add user details to Firestore
  Future<void> addUserDetails(String firstName, String lastName, String githubLink, String linkedInLink, String email, String password) async {
    await FirebaseFirestore.instance.collection('users').add({
      'firstName': firstName,
      'lastName': lastName,
      'githubLink': githubLink,
      'linkedInLink': linkedInLink,
      'email': email,
      'password': password,
    });
  }

  // Method to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
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
