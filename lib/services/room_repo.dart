import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:coin_sage/models/room.dart';
import 'package:coin_sage/services/user_repo.dart';

class RoomRepositories {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get roomDB =>
      _db.collection("Rooms");
  UserRepo userRepo = UserRepo();

  //to get all rooms
  Future<List<Room>?> getUserRooms(String email) async {
    final snapshot = await roomDB.where("members", arrayContains: email).get();
    final roomsData = snapshot.docs.map(
      (e) {
        final room = Room.fromSnapshot(e);

        return room;
      },
    ).toList();
    return roomsData;
  }

  //to add room
  Future addRoom(Room room, String userEmail) async {
    final roomID = await roomDB.add(
      room.toJson(
        userEmail,
      ),
    );

    //add requests to other members of room

    for (String e in room.members!) {
      if (e != userEmail) {
        userRepo.addRequestId(e, {roomID.id: room.title});
      }
    }

    //add room id of user creating the room
    userRepo.addRoomId(userEmail, roomID.id);
  }

  Future<Room> getRoomById(String roomId) async {
    final snapshot = await roomDB.doc(roomId).get();
    final room = Room.fromSnapshot(snapshot);
    return room;
  }

  //to get all requests of the users:
  Future<List<Room>> getRoomsRequests(String email) async {
    final request = await userRepo.getUserRequestID(email);
    final snapshot = await _db.collection("Requests").doc(request).get();

    final roomTitle = snapshot.data()!.values.toList();
    final roomSnapshot = await roomDB.where("title", whereIn: roomTitle).get();
    final roomsData = roomSnapshot.docs.map(
      (e) {
        final room = Room.fromSnapshot(e);
        return room;
      },
    ).toList();
    return roomsData;
  }

  //get room members using their id
}
