import 'dart:math'; // Import the dart:math library for generating random team code
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab3/Group/Group.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({Key? key});

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  TextEditingController _teamNameController = TextEditingController();
  TextEditingController _projectDescriptionController = TextEditingController();
  TextEditingController _teamMemberNameController = TextEditingController();

  String? _teamId; // Unique ID for the created team
  late String _teamCode = ''; // Team code for the created team, initialized with an empty string

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create A Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _teamNameController,
              decoration: InputDecoration(
                hintText: 'Enter your team name',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Project Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _projectDescriptionController,
              decoration: InputDecoration(
                hintText: 'Enter your project description',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Team Member Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _teamMemberNameController,
              decoration: InputDecoration(
                hintText: 'Enter team member name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Call function to create team
                await _createTeam();

                // Navigate to Group screen and pass the team ID as a parameter
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Group(teamId: _teamId ?? '', groupCode: _teamCode), // Pass the team ID and generated code
                  ),
                );
              },
              child: Text('Create Team'),
            ),
            SizedBox(height: 20),
            _teamId != null
                ? Text('Team ID: $_teamId') // Display team ID if available
                : Container(),
            SizedBox(height: 10),
            _teamCode.isNotEmpty
                ? Text('Team Code: $_teamCode') // Display team code if available
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> _createTeam() async {
    try {
      // Generate a random team code
      _generateTeamCode();

      // Get reference to Firestore collection "teams"
      CollectionReference teams = FirebaseFirestore.instance.collection('teams');

      // Add a new document with auto-generated ID
      DocumentReference docRef = await teams.add({
        'teamName': _teamNameController.text,
        'projectDescription': _projectDescriptionController.text,
        'teamMemberName': _teamMemberNameController.text,
        'teamCode': _teamCode, // Save the team code in Firestore
      });

      // Retrieve the auto-generated document ID
      String teamId = docRef.id;

      // Update state to display the team ID
      setState(() {
        _teamId = teamId;
      });
    } catch (e) {
      print('Error creating team: $e');
      // Handle error as needed
    }
  }

  // Function to generate a random alphanumeric team code
  void _generateTeamCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789'; // Allowed characters for the team code
    final random = Random();
    const length = 6; // Length of the team code
    _teamCode = List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
