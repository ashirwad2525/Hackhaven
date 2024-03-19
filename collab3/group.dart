import 'package:flutter/material.dart';
import 'package:collab3/Group/group_main.dart'; // Import group_main.dart

class Group extends StatefulWidget {
  final String teamId;
  final String groupCode;

  const Group({Key? key, required this.teamId, required this.groupCode}) : super(key: key);

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Team ID:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.teamId,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Group Code:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.groupCode,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the MainGroup screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainGroup()),
                );
              },
              child: Text('Move to Group'),
            ),
          ],
        ),
      ),
    );
  }
}
