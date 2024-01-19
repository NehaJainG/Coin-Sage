import 'package:coin_sage/models/user.dart';

class Room {
  Room({
    required this.id,
    required this.title,
    required this.members,
  });

  final String id;
  final String title;
  List<User> members;
}
