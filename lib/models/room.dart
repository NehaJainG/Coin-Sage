import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  Room({
    required this.id,
    required this.title,
    required this.members,
  });

  final String? id;
  final String title;
  List<String>? members;

  Map<String, dynamic> toJson(String userEmail) {
    return {
      'title': title,
      'members': [
        userEmail,
      ],
      'requestMembers':
          members!.where((element) => element != userEmail).toList(),
    };
  }

  factory Room.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Room(
      id: document.id,
      title: data['title'],
      members: data['members'] is Iterable ? List.from(data['members']) : null,
    );
  }
}
