import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:coin_sage/models/user.dart';

class UserRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get userDB =>
      _db.collection("Users");

  // to search one user with email
  Future<User?> getUser(String email) async {
    final snapshot = await userDB.where("email", isEqualTo: email).get();

    final userData = snapshot.docs.map(
      (e) {
        print('here');
        print(e.data()['members']);
        return User.fromSnapshot(e);
      },
    ).singleOrNull;

    return userData;
  }

  //to get multiple users
  Future<List<User>> getAllUsers() async {
    final snapshot = await _db.collection("Users").get();
    final userData = snapshot.docs
        .map(
          (e) => User.fromSnapshot(e),
        )
        .toList();
    return userData;
  }
}
