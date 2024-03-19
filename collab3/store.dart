import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class MyStorage extends StatefulWidget {
  const MyStorage({Key? key}) : super(key: key);

  @override
  State<MyStorage> createState() => _MyStorageState();
}

class _MyStorageState extends State<MyStorage> {
  FirebaseStorage storage = FirebaseStorage.instance;

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
        title: Text('My Storage'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Open file picker
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              String? filePath = result.files.single.path;
              if (filePath != null) {
                // File picked
                print('File picked: $filePath');
                // Upload file to Firebase Storage
                await _uploadFile(filePath);
                // Navigate back to previous screen
                Navigator.pop(context);
              }
            } else {
              // User canceled the file picker
              print('User canceled file picker');
            }
          },
          child: Text('Select File'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            minimumSize: Size(200.0, 50.0),
          ),
        ),
      ),
    );
  }
}
