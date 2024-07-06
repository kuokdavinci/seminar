import 'package:flutter/material.dart';

import '../features/a_attendance_list_tab.dart';
import 'login_page.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigo,
              bottom:   const TabBar(
                indicator: BoxDecoration(
                  color: Colors.blueAccent,

                ),
                tabs: [
                  Tab(icon: SizedBox(width:double.infinity,
                      child: Icon(Icons.calendar_today,color: Colors.white))),
                  Tab(icon: SizedBox(width:double.infinity,
                      child: Icon(Icons.calendar_month,color: Colors.white))),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _logOut,
                    child: const Text('Logout',style: TextStyle(fontSize : 15),),
                  ),
                ),
                AttendanceListTab(),
              ],
            ),
          ),
        ),),);

  }
  void _logOut()  {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}