import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainGroup extends StatefulWidget {
  const MainGroup({Key? key}) : super(key: key);

  @override
  State<MainGroup> createState() => _MainGroupState();
}

class _MainGroupState extends State<MainGroup> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _messagesCollection = FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(message['content']),
                      subtitle: Text(message['sender']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Call the method to listen for new messages
    _listenForMessages();
  }

  void _listenForMessages() {
    _messagesCollection.snapshots().listen((event) {
      // Handle the event triggered when a new message is added
      setState(() {
        // Optionally, you can update the UI here
      });
    });
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      _messagesCollection.add({
        'content': message,
        'sender': 'User', // Replace 'User' with actual sender's name or ID
        'timestamp': Timestamp.now(),
      });
      _messageController.clear(); // Clear the message input field
    }
  }
}
