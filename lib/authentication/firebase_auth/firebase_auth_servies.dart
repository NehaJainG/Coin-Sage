import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  //create authentication and firestore instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up user
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
    void Function(String) onError,
  ) async {
    try {
      //create account
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //create a document in Request DB for the current user
      final requests = _firestore.collection("Requests").doc();
      //save user info with request id in user collection
      _firestore.collection('Users').doc(credential.user!.uid).set(
        {
          'email': email,
          'name': name,
          'requestId': requests.id,
          'roomId': [],
        },
      );

      await credential.user?.updateDisplayName(name);

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        onError('The account already exists for that email.');
      } else {
        onError('${e.message}');
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //if already have account
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(String) onError,
  ) async {
    try {
      //log into existing account
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        onError('Wrong password provided for that user.');
      } else {
        onError('${e.message}');
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future logout() async {
    return await _auth.signOut();
  }
}
