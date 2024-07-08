import 'package:flutter/material.dart';
import 'package:seminar/source/resources/features/logout_tab.dart';

import '../features/a_attendance_list_tab.dart';
import '../features/a_create_course_tab.dart';
import '../features/a_create_noti_tab.dart';
import 'login_page.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<AdminHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this,);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

          body: TabBarView(
            controller: _tabController,
            children: [
              CreateCourseTab(),
              CreateNotificationTab(),
              AttendanceListTab(),
              const SizedBox(),
            ],
          ),
          bottomNavigationBar: Material(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(25),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 25),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(25),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs:  [
                  const Tab(icon: Icon(Icons.add_circle, color:Colors.white,size: 30,),),
                  const Tab(icon: Icon(Icons.notification_add, color:Colors.white,size: 30),),
                  const Tab(icon: Icon(Icons.check_circle, color:Colors.white,size: 30),),
                  Tab(icon: IconButton(onPressed:() {
                    _LogOut(context);
                  }, icon:const Icon(Icons.logout, color:Colors.white,size: 30), )),
                ],
              ),
            ),
          ),
    );
  }
  void _LogOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Logging out this account ?',style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}