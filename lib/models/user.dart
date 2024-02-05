import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
  });
  final String id;
  final String name;
  final String email;

  toJson() {
    return {'email': email, 'name': name};
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return User(
      id: document.id,
      name: data['name'],
      email: data['email'],
    );
  }
}
