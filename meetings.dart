import 'package:flutter/material.dart';

class MyMeetings extends StatefulWidget {
  const MyMeetings({Key? key}) : super(key: key);

  @override
  State<MyMeetings> createState() => _MyMeetingsState();
}

class _MyMeetingsState extends State<MyMeetings> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  TextEditingController _meetingDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Meeting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 8),
                  Text(
                    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Select Time:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: _pickTime,
              child: Row(
                children: [
                  Icon(Icons.access_time),
                  SizedBox(width: 8),
                  Text(
                    '${_selectedTime.hour}:${_selectedTime.minute}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Meeting Details:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _meetingDetailsController,
              decoration: InputDecoration(
                hintText: 'Enter meeting details',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _scheduleMeeting,
              child: Text('Schedule Meeting'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _scheduleMeeting() {
    // Implement your logic here to schedule the meeting
    final DateTime scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    final String meetingDetails = _meetingDetailsController.text;

    // You can now use scheduledDateTime and meetingDetails to schedule the meeting
    // For example, you can send this information to a backend server or store it locally.
    print('Meeting scheduled for: $scheduledDateTime');
    print('Meeting details: $meetingDetails');
  }

  @override
  void dispose() {
    _meetingDetailsController.dispose();
    super.dispose();
  }
}
