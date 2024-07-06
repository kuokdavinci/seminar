// import 'dart:io';
//
// import 'package:seminar/source/resources/features/facedetect/camera.dart';
// import 'package:camera/camera.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:seminar/source/resources/pages/home_page.dart';
//
// class DetectPage extends StatefulWidget {
//   final XFile? image;
//
//   const DetectPage({Key? key, this.image}) : super(key: key);
//
//   @override
//   _DetectPageState createState() => _DetectPageState();
// }
//
// class _DetectPageState extends State<DetectPage> {
//   XFile? image;
//   final controllerName = TextEditingController();
//   final CollectionReference dataCollection = FirebaseFirestore.instance
//       .collection('absensi');
//
//   @override
//   void initState() {
//     super.initState();
//     image = widget.image;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery
//         .of(context)
//         .size;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         margin: const EdgeInsets.only(top: 70),
//         child: SingleChildScrollView(
//           child: Card(
//             color: Colors.white,
//             margin: const EdgeInsets.fromLTRB(10, 10, 10, 30),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             elevation: 5,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 50,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10),
//                     ),
//                     color: Colors.indigo,
//                   ),
//                   child: const Row(
//                     children: [
//                       SizedBox(width: 24),
//                       Text(
//                         "Capture your face to continue",
//                         style: TextStyle(fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 70),
//                   child: GestureDetector(
//                     onTap:
//                     child: Container(
//                       margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
//                       width: size.width,
//                       height: 150,
//                       child: DottedBorder(
//                         radius: Radius.circular(10),
//                         borderType: BorderType.RRect,
//                         color: Colors.indigo,
//                         strokeWidth: 1,
//                         dashPattern: [5, 5],
//                         child: SizedBox.expand(
//                           child: FittedBox(
//                             child: image != null
//                                 ? Image.file(
//                                 File(image!.path), fit: BoxFit.cover)
//                                 : const Icon(
//                               Icons.camera_alt_outlined,
//                               color: Colors.indigo,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.center,
//                   margin: const EdgeInsets.all(30),
//                   child: Material(
//                     elevation: 3,
//                     borderRadius: BorderRadius.circular(20),
//                     child: Container(
//                       width: size.width,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.white,
//                       ),
//                       child: Material(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.indigo,
//                         child: InkWell(
//                           splashColor: Colors.indigo,
//                           borderRadius: BorderRadius.circular(20),
//                           onTap: () {
//                             if (image == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.info_outline,
//                                         color: Colors.white,
//                                       ),
//                                       SizedBox(width: 10),
//                                       Text(
//                                         "Images can't be empty!",
//                                         style: TextStyle(color: Colors.white),
//                                       )
//                                     ],
//                                   ),
//                                   backgroundColor: Colors.redAccent,
//                                   shape: StadiumBorder(),
//                                   behavior: SnackBarBehavior.floating,
//                                 ),
//                               );
//                             } else {}
//                           },
//                           child: const Center(
//                             child: Text(
//                               "Face Authencation",
//                               style: TextStyle(color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void showLoaderDialog(BuildContext context) {
//     AlertDialog alert = AlertDialog(
//       content: Row(
//         children: [
//           const CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.indigoAccent)),
//           Container(
//             margin: const EdgeInsets.only(left: 20),
//             child: const Text("Loaing..."),
//           ),
//         ],
//       ),
//     );
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
// }
