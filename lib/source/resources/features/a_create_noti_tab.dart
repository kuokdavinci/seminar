import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/login_page.dart';

class CreateNotificationTab extends StatefulWidget {
  @override
  _CreateNotificationTabState createState() => _CreateNotificationTabState();
}

class _CreateNotificationTabState extends State<CreateNotificationTab> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _sendNotification() async {
    String title = _titleController.text;
    String message = _messageController.text;

    if (title.isNotEmpty && message.isNotEmpty) {
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            margin: EdgeInsets.only(bottom: 100,left: 30,right:30),
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "Sent notification successfully!",
                  style: TextStyle(color: Colors.white,fontSize: 17),
                )
              ],
            ),
            backgroundColor: Colors.lightGreen,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Create Notification',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30,),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: _sendNotification,
              child: const Text(
                'Send notification',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }
}
