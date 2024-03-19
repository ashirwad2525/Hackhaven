import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final TextEditingController _taskController = TextEditingController();
  late CollectionReference _tasksCollection;

  @override
  void initState() {
    super.initState();
    _tasksCollection = FirebaseFirestore.instance.collection('tasks');
  }

  Future<void> _addTask(String taskName) async {
    try {
      await _tasksCollection.add({'name': taskName});
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> _updateTask(String taskId, String updatedTaskName) async {
    try {
      await _tasksCollection.doc(taskId).update({'name': updatedTaskName});
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _taskController,
            decoration: InputDecoration(
              labelText: 'Task',
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _addTask(_taskController.text.trim());
                  _taskController.clear();
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _tasksCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    String taskId = document.id;

                    return ListTile(
                      title: Text(data['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Edit Task'),
                                    content: TextField(
                                      controller: TextEditingController(text: data['name']),
                                      onChanged: (value) {
                                        // Handle text change
                                      },
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          _updateTask(taskId, _taskController.text.trim());
                                          Navigator.pop(context);
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteTask(taskId);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
