

import 'package:flutter/material.dart';
import 'package:seminar/source/resources/pages/home_page.dart';
import "package:slide_to_act/slide_to_act.dart" show SlideAction, SlideActionState;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart' show Placemark, placemarkFromCoordinates;
import '../../model/user.dart';
import '../../services/location_service.dart';

class CheckInTab extends StatefulWidget {
  const CheckInTab({Key? key, required this.courseName, }) : super(key: key);

  final String courseName;
  @override
  State<CheckInTab> createState() => _CheckInTabState();
}

class _CheckInTabState extends State<CheckInTab> {
  double screenHeight = 0;
  double screenWidth = 0;
  String checkIn = '--/--';
  String checkOut = '--/--';
  String userName = '';
  String location = ' ';

  @override
  void initState() {
    super.initState();
    _getRecord();
    _startLocationService();
  }
  void _startLocationService() async {
    LocationService locationService = LocationService();

    await locationService.initialize();

    double? longitude = await locationService.getLongitude();
    double? latitude = await locationService.getLatitude();

    if (longitude != null && latitude != null) {
      setState(() {
        localUser.long = longitude;
        localUser.lat = latitude;
      });
      _getLocation();
    } else {
      print('Error: Unable to get location coordinates.');
    }
  }

  void _getLocation() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(localUser.lat, localUser.long);
      if (placemarks.isNotEmpty) {
        setState(() {
          location =
          "${placemarks[0].street},"
              " ${placemarks[0].administrativeArea}, "
              "${placemarks[0].subAdministrativeArea}, "
              "${placemarks[0].country}";
          print(location);
        });
      } else {
        print('Error: No placemarks found.');
      }
        } catch (e) {
      print('Error getting location: $e');
    }
  }

  _getRecord() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user!.uid;
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Records')
          .doc(DateFormat('dd MM yyyy').format(DateTime.now()))
          .get();

      DocumentSnapshot snap2 =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      userName = snap2['name'];
      setState(() {
        checkIn = snap['CheckIn'];
        checkOut = snap['CheckOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = '--/--';
        checkOut = '--/--';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage(initialTabIndex: 1)));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "$userName",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  "Course: ${widget.courseName}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40, left: 25, right: 25),
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Check In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            checkIn,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Check Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            checkOut,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              checkOut == "--/--"
                  ? Container(
                margin: const EdgeInsets.only(top: 25),
                child: Builder(
                  builder: (context) {
                    final GlobalKey<SlideActionState> key = GlobalKey();

                    return SlideAction(
                      animationDuration: const Duration(milliseconds: 500),
                      text: checkIn == "--/--" ? "Slide to Check In!" : "Slide to Check Out!",
                      textStyle: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                      outerColor: Colors.indigo,
                      innerColor: Colors.white,
                      key: key,
                      onSubmit: () async {
                          User? user = FirebaseAuth.instance.currentUser;
                          String userId = user!.uid;
                          DocumentSnapshot snap = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection('Records')
                              .doc(DateFormat('dd MM yyyy').format(DateTime.now()))
                              .get();

                          String currentTime = DateFormat('hh:mm').format(DateTime.now());

                          if (localUser.lat != 0) {
                            _getLocation();
                            try {
                              String checkInTime = snap['CheckIn'];
                              setState(() {
                                checkOut = currentTime;
                              });
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .collection("Records")
                                  .doc(DateFormat('dd MM yyyy').format(DateTime.now()))
                                  .update({
                                'CheckIn': checkInTime,
                                'CheckOut': currentTime,
                                'CheckOutLocation': location,
                              });
                            } catch (e) {
                              setState(() {
                                checkIn = currentTime;
                              });
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .collection("Records")
                                  .doc(DateFormat('dd MM yyyy').format(DateTime.now()))
                                  .set({
                                'CheckIn': currentTime,
                                'CheckOut': '--/--',
                                'CheckInLocation': location,
                                'CourseName': widget.courseName,
                              });
                            }
                          } else {
                            try {
                              String checkInTime = snap['CheckIn'];
                              setState(() {
                                checkOut = currentTime;
                              });
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .collection("Records")
                                  .doc(DateFormat('dd MM yyyy').format(DateTime.now()))
                                  .update({
                                'CheckIn': checkInTime,
                                'CheckOut': currentTime,
                                'CheckOutLocation': location,
                              });
                            } catch (e) {
                              setState(() {
                                checkIn = currentTime;
                              });
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .collection("Records")
                                  .doc(DateFormat('dd MM yyyy').format(DateTime.now()))
                                  .set({
                                'CheckIn': currentTime,
                                'CheckOut': '--/--',
                                'CheckInLocation': location,
                              });
                            }
                          }
                          key.currentState!.reset();
                      },
                    );



                  },
                ),
              )
                  : Container(
                margin: const EdgeInsets.only(top: 40),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.lightGreen),SizedBox(width: 5,),  Text(
                      'Check out successfully !',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
