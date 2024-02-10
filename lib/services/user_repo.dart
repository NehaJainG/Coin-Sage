import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:coin_sage/models/user.dart';

class UserRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get userDB =>
      _db.collection("Users");

  // to search one user with email
  Future<User?> getUser(String email) async {
    print('here');
    print(email);
    final snapshot = await userDB.where("email", isEqualTo: email).get();

    final userData = snapshot.docs.map(
      (e) {
        return User.fromSnapshot(e);
      },
    ).firstOrNull;
    print(userData!.email);
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

  // so if someone adds to room they get request id
  Future<String> getUserRequestID(String email) async {
    final snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    print(snapshot);
    final requestID = snapshot.docs
        .map(
          (e) => e.data()["requestId"],
        )
        .first;
    print(requestID);
    return requestID;
  }

  Future addRequestId(String email, Map<String, String> room) async {
    final requestId = await getUserRequestID(email);
    await _db.collection("Requests").doc(requestId).update(room);
  }

  Future removeRequestId(String email, String roomId) async {
    final requestId = await getUserRequestID(email);

    //remove useremail from array of requestMembers
    _db.collection("Rooms").doc(roomId).update(
      {
        "requestMembers": FieldValue.arrayRemove([email]),
      },
    );

    //remove room details of user from request collection
    await _db.collection("Requests").doc(requestId).set(
      {
        roomId: FieldValue.delete(),
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  Future addRoomId(String userEmail, String roomID) async {
    print('add room');
    final userID = await getUser(userEmail);
    print('returns');
    print(userID);
    //add room detail to user collection
    await userDB.doc(userID!.id).update(
      {
        "roomId": FieldValue.arrayUnion([roomID]),
      },
    );
    //add useremail from array of requestMembers
    _db.collection("Rooms").doc(roomID).update(
      {
        "members": FieldValue.arrayUnion([userEmail]),
      },
    );
  }
}
