import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart' show FaceDetector, FaceDetectorOptions;

class Vision {
  Vision._();

  static final Vision instance = Vision._();

  FaceDetector faceDetector([FaceDetectorOptions? options]) {
    return FaceDetector(options: options ?? FaceDetectorOptions());
  }
}