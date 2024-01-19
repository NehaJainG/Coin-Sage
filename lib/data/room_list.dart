import 'package:coin_sage/models/user.dart';
import 'package:coin_sage/models/room.dart';

User user1 = User(id: '1', name: 'Alice');
User user2 = User(id: '2', name: 'Bob');
User user3 = User(id: '3', name: 'Charlie');

List<Room> dummyRooms = [
  Room(
    id: 'room1',
    title: 'Home',
    members: [user1, user2],
  ),
  Room(
    id: 'room2',
    title: 'Friends',
    members: [user2, user3],
  ),
  Room(
    id: 'room3',
    title: 'Partner',
    members: [user1, user3],
  ),
];
