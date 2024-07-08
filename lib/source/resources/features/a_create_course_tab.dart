import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CreateCourseTab extends StatefulWidget {
  @override
  _CreateCourseTabState createState() => _CreateCourseTabState();
}

class _CreateCourseTabState extends State<CreateCourseTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.inputOnly;
  String _courseName = '';

  @override
  void initState() {
    super.initState();
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay.now();
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      initialEntryMode: initialEntryMode,
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      initialEntryMode: initialEntryMode,
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, now.day, _startTime.hour, _startTime.minute);
      DateTime endDate = DateTime(now.year, now.month, now.day, _endTime.hour, _endTime.minute);
      String starttime = DateFormat('HH:mm').format(startDate);
      String endtime = DateFormat('HH:mm').format(endDate);

      try {
        await FirebaseFirestore.instance.collection('courses').add({
          'name': _courseName,
          'time_start': starttime,
          'time_end': endtime,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              margin: EdgeInsets.only(bottom: 30,left: 30,right:30),
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Course created successfully!",
                    style: TextStyle(color: Colors.white,fontSize: 17),
                  )
                ],
              ),
              backgroundColor: Colors.lightGreen,
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
            ));
        // Clear form after submission if needed
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              margin: EdgeInsets.only(bottom: 100,left: 30,right:30),
              content: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Failed to create course!",
                    style: TextStyle(color: Colors.white,fontSize: 17),
                  )
                ],
              ),
              backgroundColor: Colors.redAccent,
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal:30,vertical: 30 ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Create Notification',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Course Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter course name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _courseName = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                 Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text('Start: '),
                        trailing: InkWell(
                          onTap: () => _selectStartTime(context),
                          child: Text('${_startTime.format(context)}',style: TextStyle(fontSize: 18),),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0), // Optional space between ListTiles
                    Expanded(
                      child: ListTile(
                        title: Text('End: '),
                        trailing: InkWell(
                          onTap: () => _selectEndTime(context),
                          child: Text('${_endTime.format(context)}',style: TextStyle(fontSize: 18),),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _submitForm,
                    child: const Text('Create Course',style: TextStyle(fontSize: 22)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String format(BuildContext context) => MaterialLocalizations.of(context).formatTimeOfDay(this, alwaysUse24HourFormat: true);
}
