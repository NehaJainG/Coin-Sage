import 'package:flutter/material.dart';

import 'package:coin_sage/data/room_list.dart';
import 'package:coin_sage/assets/icon.dart';
import 'package:coin_sage/assets/defaults.dart';
import 'package:coin_sage/models/room.dart';
import 'package:coin_sage/screens/add_new_room.dart';
import 'package:coin_sage/screens/room_detail.dart';

class UserRoomsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Rooms'), actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddRoomScreen(),
            ));
          },
          icon: addIcon,
        )
      ]),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (Room roomItem in dummyRooms) RoomCard(room: roomItem),
            for (Room roomItem in dummyRooms) RoomCard(room: roomItem)
          ],
        ),
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RoomDetailsScreen(room: room),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.2),
              //spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(2, 5), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                color: blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('date'),
                  const SizedBox(height: 8),
                  Text(
                    room.title,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                color: black,
              ),
              child: Text(
                'room.members',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
