import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AttendanceListTab extends StatelessWidget {
  Future<Map<DateTime, List<Map<String, dynamic>>>> fetchAttendanceByDate() async {
    Map<DateTime, List<Map<String, dynamic>>> attendanceByDate = {};
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    for (var userDoc in usersSnapshot.docs) {
      String userId = userDoc['id'];
      String userName = userDoc['name'];
      CollectionReference recordsRef = FirebaseFirestore.instance.collection('users/${userDoc.id}/Records');

      QuerySnapshot recordsSnapshot = await recordsRef.get();

      for (var recordDoc in recordsSnapshot.docs) {
        String dateString = recordDoc.id;
        DateTime date = DateFormat('dd MM yyyy').parse(dateString); // Parse dateString to DateTime
        Map<String, dynamic> recordData = recordDoc.data() as Map<String, dynamic>;
        recordData['userId'] = userId;
        recordData['userName'] = userName;

        if (!attendanceByDate.containsKey(date)) {
          attendanceByDate[date] = [];
        }
        attendanceByDate[date]!.add(recordData);
      }
    }

    // Sort by DateTime in ascending order
    attendanceByDate.forEach((key, value) {
      value.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    });

    return attendanceByDate;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<DateTime, List<Map<String, dynamic>>>>(
      future: fetchAttendanceByDate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No attendance records found.'));
        } else {
          Map<DateTime, List<Map<String, dynamic>>> attendanceByDate = snapshot.data!;
          List<DateTime> sortedDates = attendanceByDate.keys.toList();
          sortedDates.sort((a, b) => a.compareTo(b));

          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top:50),
                child: const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    'Attendance List',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Expanded(
                child: ListView(
                  children: sortedDates.map((date) {
                    List<Map<String, dynamic>> records = attendanceByDate[date]!;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 7),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                        )
                      ),
                      child: ExpansionTile(
                        title: Text(DateFormat('dd/MM/yyyy').format(date)), // Format date for display
                        children: records.map((record) {
                          return ListTile(
                            title: Text('${record['userName']} - ${record['userId']}'),
                            subtitle: Text('Course: ${record['CourseName']}\nCheckIn: ${record['CheckIn']}\nLocation: ${record['CheckInLocation']}\nCheckOut: ${record['CheckOut']}\nLocation: ${record['CheckOutLocation']}'),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
