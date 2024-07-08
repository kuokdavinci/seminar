import 'package:flutter/material.dart';

class LogoutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Logout'),
                    content: Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                      ),
                      TextButton(
                        child: Text('Logout'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          // Navigate to LoginPage
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Logout'),
          ),
        ),
      ),
    );
  }

}
