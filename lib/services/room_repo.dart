import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:coin_sage/models/room.dart';

class RoomRepositories {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get roomDB =>
      _db.collection("Rooms");

  //to get all rooms
  Future<List<Room>?> getRooms() async {
    final snapshot = await roomDB.get();
    final roomsData = snapshot.docs.map(
      (e) {
        final room = Room.fromSnapshot(e);

        return room;
      },
    ).toList();
    return roomsData;
  }

  //to add room
  Future addRoom(Room room) async {
    await roomDB.add(room.toJson());
  }
}
