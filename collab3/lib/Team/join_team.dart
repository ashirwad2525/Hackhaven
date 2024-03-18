import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab3/Group/group_main.dart'; // Import group_main.dart

class JoinTeam extends StatefulWidget {
  const JoinTeam({Key? key});

  @override
  State<JoinTeam> createState() => _JoinTeamState();
}

class _JoinTeamState extends State<JoinTeam> {
  TextEditingController _teamCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join A Team'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Team Code:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              child: TextField(
                controller: _teamCodeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Team Code',
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Validate the entered team code
                bool isValidCode = await _validateTeamCode(_teamCodeController.text);
                if (isValidCode) {
                  // Navigate to the Group screen if team code is valid
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainGroup(),
                    ),
                  );
                } else {
                  // Show an error message for invalid team code
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid Team code. Please try again.'),
                    ),
                  );
                }
              },
              child: Text('Join'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _validateTeamCode(String code) async {
    try {
      // Query Firestore to check if the entered code exists in the teams collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('teams').where('teamCode', isEqualTo: code).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error validating Team code: $e');
      return false;
    }
  }
}
