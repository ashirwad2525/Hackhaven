import 'dart:io';

import 'package:collab3/Group/message.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';
import 'package:collab3/Group/store.dart';
import 'package:collab3/Group/Tasks.dart'; // Import the Tasks screen
import 'package:collab3/Group/meetings.dart'; // Import the MyMeetings screen
import 'package:collab3/Group/message.dart'; // Import the MyMessage screen

class MainGroup extends StatefulWidget {
  const MainGroup({Key? key}) : super(key: key);

  @override
  State<MainGroup> createState() => _MainGroupState();
}

class _MainGroupState extends State<MainGroup> {
  FirebaseStorage storage = FirebaseStorage.instance;
  List<String> uploadedFiles = [];

  Future<String?> _uploadFile(String filePath) async {
    File file = File(filePath);
    String fileName = path.basename(file.path);
    try {
      TaskSnapshot snapshot = await storage.ref('uploads/$fileName').putFile(file);
      String downloadURL = await snapshot.ref.getDownloadURL();
      print('File uploaded successfully: $downloadURL');
      return downloadURL;
    } catch (error) {
      print('Error uploading file: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Group'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.0,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyStorage()),
                  );
                },
                child: Text('Upload Files'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5.0,
                  shadowColor: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Tasks()), // Navigate to Tasks screen
                      );
                    },
                    child: Text('Tasks'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  width: 150.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyMeetings()), // Navigate to MyMeetings screen
                      );
                    },
                    child: Text('Meetings'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200.0,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyMessage(groupId: 'your_group_id_here'),
                    ),
                  );
                  ;
                },
                child: Text('Messages'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5.0,
                  shadowColor: Colors.grey,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: uploadedFiles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await launch(uploadedFiles[index]);
                    },
                    child: ListTile(
                      title: Text('Image ${index + 1}'),
                      leading: Image.network(
                        uploadedFiles[index],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
