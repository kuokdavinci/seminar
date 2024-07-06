import "package:firebase_auth/firebase_auth.dart" show FirebaseAuth, User, UserCredential;
import "package:cloud_firestore/cloud_firestore.dart" show CollectionReference, FirebaseFirestore;


class FireAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String pass, String name, String id) async {
    try {
      // Đăng ký người dùng với Firebase Authentication
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: pass);

      // Kiểm tra xem đăng ký đã thành công hay không
      if (credential.user != null) {
        // Nếu đăng ký thành công, thêm thông tin của người dùng vào Firestore
        await addUserToFirestore(credential.user!.uid, name, email, id);
        return credential.user;
      } else {
        // Xử lý trường hợp đăng ký không thành công
        print('Failed to sign up user.');
        return null;
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      print('Error signing up user: $error');
      return null;
    }
  }
  Future <User?> signInWithEmailAndPassword(String email,String pass,bool onSuccess) async{

    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User? user = credential.user;
      return user;
    }catch(e){
      onSuccess =false;
      print('Email or Password is incorrect');
    }
    return null;
  }
  Future<void> addUserToFirestore(String uid, String name, String email, String id) async {
    try {
      CollectionReference users = _firestore.collection('users');

      await users.doc(uid).set({
        'name': name,
        'email': email,
        'id': id,
        'isAdmin': false,
        'faculty' : 'Not selected yet',
        'department' : 'Not selected yet',
      });
    } catch (error) {
      print('Error adding user to Firestore: $error');
    }
  }

}
