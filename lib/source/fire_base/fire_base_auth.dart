import "package:firebase_auth/firebase_auth.dart" show FirebaseAuth, User, UserCredential;
import "package:cloud_firestore/cloud_firestore.dart" show CollectionReference, FirebaseFirestore;


class FireAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String pass, String name, String id) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: pass);

      if (credential.user != null) {
        await addUserToFirestore(credential.user!.uid, name, email, id);
        return credential.user;
      } else {
        print('Failed to sign up user.');
        return null;
      }
    } catch (error) {
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
