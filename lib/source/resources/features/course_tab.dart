import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:seminar/source/resources/features/facedetect/camera.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseTab extends StatefulWidget {
  const CourseTab({Key? key, this.image}) : super(key: key);
  final XFile? image;

  @override
  _CourseTabState createState() => _CourseTabState();
}

class _CourseTabState extends State<CourseTab> {
  late Future<List<DocumentSnapshot>> coursesFuture;
  XFile? image;

  @override
  void initState() {
    super.initState();
    coursesFuture = fetchCourses();
    image = widget.image;
  }

  Future<List<DocumentSnapshot>> fetchCourses() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('courses').get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  bool isInTimeRange(String timeStart, String timeEnd) {
    String now = DateFormat('HH:mm').format(DateTime.now());
    DateTime nowTime = DateFormat('HH:mm').parse(now);
    DateTime startTime = DateFormat('HH:mm').parse(timeStart);
    DateTime endTime = DateFormat('HH:mm').parse(timeEnd);
    return nowTime.isAfter(startTime) && nowTime.isBefore(endTime);
  }

  Future<void> addCourseNameToFirestore(String courseName) async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    String todayDate = DateFormat('dd MM yyyy').format(DateTime.now());

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Records')
          .doc(todayDate)
          .set({
        'CourseName': courseName,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding course name: $e');
    }
  }

  Future<String> fetchCheckOutStatus(String courseName) async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    String todayDate = DateFormat('dd MM yyyy').format(DateTime.now());

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Records')
          .doc(todayDate)
          .get();
      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data() as Map<String, dynamic>;
        if (data['CourseName'] == courseName && data['CheckOut'] != null) {
          return data['CheckOut'];
        }
      }
      return '--/--';
    } catch (e) {
      print('Error fetching checkout status: $e');
      return '--/--';
    }
  }

  bool isCheckOutToday(String checkOut) {
    String todayDate = DateFormat('dd MM yyyy').format(DateTime.now());
    return checkOut == todayDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Your Courses',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No courses found.'));
                  } else {
                    List<DocumentSnapshot> courses = snapshot.data!;
                    return ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        String courseName = courses[index]['name'];
                        String timeStart = courses[index]['time_start'];
                        String timeEnd = courses[index]['time_end'];
                        String timeRange = '$timeStart - $timeEnd';

                        return FutureBuilder<String>(
                          future: fetchCheckOutStatus(courseName),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              String checkOut = snapshot.data ?? '--/--';

                              bool isCurrentTimeInRange = isInTimeRange(timeStart, timeEnd);
                              bool isCheckedOut = checkOut != '--/--';

                              IconData iconData = isCurrentTimeInRange
                                  ? isCheckedOut ? Icons.check_circle : Icons.timer
                                  : Icons.close;

                              Color iconColor = isCurrentTimeInRange
                                  ? isCheckedOut ? Colors.lightGreen : Colors.indigo
                                  : Colors.red;

                              return GestureDetector(
                                onTap: () async {
                                  if (isCurrentTimeInRange) {
                                    await addCourseNameToFirestore(courseName);
                                    pickImage(courseName);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Can't check in at this time",
                                              style: TextStyle(color: Colors.white, fontSize: 17),
                                            )
                                          ],
                                        ),
                                        backgroundColor: Colors.redAccent,
                                        shape: StadiumBorder(),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              courseName,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              timeRange,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: isCurrentTimeInRange
                                                    ? isCheckedOut ? Colors.lightGreen : Colors.indigo
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        iconData,
                                        color: iconColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(String courseName) async {
    final XFile? image = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraPage(courseName: courseName)),  // Truyền tên môn học qua CameraPage
    );
    if (image != null) {
      setState(() {
        this.image = image;
      });
    }
  }
}
