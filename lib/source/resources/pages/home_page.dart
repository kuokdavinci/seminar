import 'package:flutter/material.dart';
import 'package:seminar/source/resources/features/facedetect/detect.dart';
import '../features/account_tab.dart';
import '../features/course_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.initialTabIndex});
  final int initialTabIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          AccountTab(),
          const CourseTab(),
          const Icon(Icons.check_circle, size: 350),
          const Icon(Icons.check_circle, size: 350),
        ],
      ),
      bottomNavigationBar: Material(
        // color: Colors.indigo,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(25),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 25),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(25),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                icon: Icon(Icons.account_circle, color:Colors.white,size: 30,),
              ),
              Tab(
                icon: Icon(Icons.calendar_today, color:Colors.white,size: 30),
              ),
              Tab(
                icon: Icon(Icons.camera_alt, color:Colors.white,size: 30),
              ),
              Tab(
                icon: Icon(Icons.check_circle, color:Colors.white,size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
