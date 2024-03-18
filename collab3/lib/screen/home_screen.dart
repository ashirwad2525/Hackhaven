import 'package:collab3/Team/create_team.dart';
import 'package:collab3/Team/join_team.dart'; // Import the join team screen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signin_screen.dart'; // Import the sign-in screen to navigate to after logging out
import 'package:collab3/Team/create_team.dart'; // Import the create team screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dashboard', // Set the title to "Dashboard"
              textAlign: TextAlign.center, // Center align the title
            ),
            SizedBox(width: 8), // Add some space between the title and the circular button
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to create team screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTeam()), // Replace CreateTeam with your actual screen name
                );
              },
              child: Text('Create a Team'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to join team screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinTeam()), // Replace JoinTeam with your actual screen name
                );
              },
              child: Text('Join a Team'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          // Perform logout logic here
          _logout(context);
        },
        tooltip: 'Logout',
        child: Icon(Icons.logout),
      ),
    );
  }

  // Method to logout and navigate to sign-in screen
  void _logout(BuildContext context) {
    // You can perform logout logic here
    // For simplicity, let's just navigate to the sign-in screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }
}
