import 'dart:io';

import 'package:seminar/source/resources/features/check_in_tab.dart';
import 'package:seminar/source/resources/utils/google_ml_kit.dart';
import 'package:camera/camera.dart' show CameraController, CameraDescription, CameraLensDirection, CameraPreview, FlashMode, ResolutionPreset, XFile, availableCameras;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart' show FaceDetector, FaceDetectorOptions, InputImage;
import 'package:lottie/lottie.dart' show Lottie;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../pages/home_page.dart';

class CameraPage extends StatefulWidget {
  final String courseName;

  const CameraPage({super.key, required this.courseName});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableTracking: true,
        enableLandmarks: true,
      ));

  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      for (CameraDescription camera in cameras!) {
        if (camera.lensDirection == CameraLensDirection.front) {
          controller = CameraController(camera, ResolutionPreset.max);
          break;
        }
      }
      controller ??= CameraController(cameras![0], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } else {
      showSnackBar("Camera not found", Icons.camera_enhance_outlined, Colors.redAccent);
    }
  }

  Future<String?> uploadImageToFirebase(XFile imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      await imageRef.putFile(File(imageFile.path));
      final downloadURL = await imageRef.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> saveUrlToFirestore(String courseName, String imageUrl) async {
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
        'ImageUrl': imageUrl,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving URL to Firestore: $e');
    }
  }

  void showSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: color,
        shape: const StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void showLoaderDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo)),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Text("Currently checking data..."),
            ),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomePage(initialTabIndex: 1)));
          },
        ),
        title: const Text(
          "Face Authentication",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: controller == null
                ? const Center(child: Text("Camera problem", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
                : !controller!.value.isInitialized
                ? const Center(child: CircularProgressIndicator())
                : CameraPreview(controller!),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Lottie.asset(
              "assets/raw/face_id_ring.json",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Make sure you are in a place with good lighting conditions",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: ClipOval(
                      child: Material(
                        color: Colors.indigo,
                        child: InkWell(
                          splashColor: Colors.indigoAccent,
                          onTap: () async {
                            try {
                              if (controller != null && controller!.value.isInitialized) {
                                controller!.setFlashMode(FlashMode.off);
                                image = await controller!.takePicture();
                                setState(() {
                                  showLoaderDialog(context);
                                  final inputImage = InputImage.fromFilePath(image!.path);
                                  processImage(inputImage);
                                });
                              }
                            } catch (e) {
                              showSnackBar("$e", Icons.error_outline, Colors.redAccent);
                            }
                          },
                          child: const SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    isBusy = false;

    if (mounted) {
      setState(() {
        Navigator.of(context).pop(true);
        if (faces.isNotEmpty) {
          uploadImageToFirebase(image!).then((downloadURL) {
            if (downloadURL != null) {
              saveUrlToFirestore(widget.courseName, downloadURL).then((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckInTab(courseName: widget.courseName),
                  ),
                );
              });
            } else {
              showSnackBar("Error uploading image", Icons.error_outline, Colors.redAccent);
            }
          });
        } else {
          showSnackBar("Can't detect your face", Icons.face_retouching_natural_outlined, Colors.redAccent);
        }
      });
    }
  }
}
