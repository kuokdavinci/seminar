import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart" show FirebaseAuth, User;
import "package:cloud_firestore/cloud_firestore.dart" show DocumentSnapshot, FirebaseFirestore, QuerySnapshot;
import 'package:flutter/widgets.dart';
import 'package:seminar/source/resources/pages/login_page.dart';

class AccountTab extends StatefulWidget {
  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  List<String> faculties = [];
  String _selectedFaculty = 'Not selected yet';
  List<String> departments = [];
  String _selectedDepartment = 'Not selected yet';

  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadUserData();
    _loadFaculties();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot userData = await _firestore.collection('users').doc(user!.uid).get();
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

      setState(() {
        _nameController.text = data['name'];
        _idController.text = data['id'];
        _phoneController.text = data['phone'];
        _selectedFaculty = data['faculty'] ?? 'Not selected yet';
        _selectedDepartment = data['department'] ?? 'Not selected yet';
      });

      _updateDepartments();
    }
  }

  Future<void> _loadFaculties() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('faculties').get();
      for (var doc in querySnapshot.docs) {
        faculties.add(doc['name']);
      }
    } catch (e) {
      print('Error getting faculties: $e');
    }
    setState(() {
      _dataLoaded = true;
    });
  }

  Future<void> _updateUserData() async {
    if (user != null && _selectedFaculty != 'Not selected yet' && _selectedDepartment != 'Not selected yet') {
      await _firestore.collection('users').doc(user!.uid).update({
        'name': _nameController.text,
        'id': _idController.text,
        'phone': _phoneController.text,
        'faculty': _selectedFaculty,
        'department': _selectedDepartment,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            margin: EdgeInsets.only(top:20,left: 30,right:30),
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "Update information successfully!",
                  style: TextStyle(color: Colors.white,fontSize: 17),
                )
              ],
            ),
            backgroundColor: Colors.lightGreen,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            margin: EdgeInsets.only(top: 20,left: 30,right:30),
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "Faculty can't be empty",
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

  Future<void> _updateDepartments() async {
    List<String> departmentsList = ['Not selected yet'];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('departments')
          .where('faculty', isEqualTo: _selectedFaculty)
          .get();

      for (var doc in querySnapshot.docs) {
        departmentsList.add(doc['name']);
      }
    } catch (e) {
      print('Error getting departments: $e');
    }

    setState(() {
      departments = departmentsList;
      if (!departments.contains(_selectedDepartment)) {
        _selectedDepartment = 'Not selected yet';
      }
    });
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems(List<String> items) {
    return items.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(minWidth: double.infinity, maxWidth: double.infinity),
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        child: Padding(
          padding: const EdgeInsets.symmetric( vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Account Information',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedFaculty,
                items: _buildDropdownMenuItems(_dataLoaded ? faculties : []),
                onChanged: (value) {
                  setState(() {
                    _selectedFaculty = value ?? 'Not selected yet';
                    _updateDepartments();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Faculty',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                items: _buildDropdownMenuItems(_dataLoaded ? departments : []),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value ?? 'Not selected yet';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _updateUserData,
                  child: const Text(
                    'Save information',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
