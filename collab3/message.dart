import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyMessage extends StatefulWidget {
  final String groupId; // Add groupId as a parameter

  const MyMessage({Key? key, required this.groupId}) : super(key: key);

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      _firestore.collection('messages_${widget.groupId}').add({
        'text': messageText,
        'createdAt': DateTime.now(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages_${widget.groupId}')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageText = message['text'];
                  final messageWidget = Text(messageText);
                  messageWidgets.add(messageWidget);
                }
                return ListView(
                  reverse: true,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: MyMessage(groupId: 'group1'), // Pass the group ID here
  ));
}
