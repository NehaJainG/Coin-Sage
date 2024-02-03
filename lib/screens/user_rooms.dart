import 'package:flutter/material.dart';

import 'package:coin_sage/data/room_list.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/colors.dart';

import 'package:coin_sage/screens/add_new_room.dart';
import 'package:coin_sage/screens/room_detail.dart';

class UserRoomsScreen extends StatefulWidget {
  @override
  State<UserRoomsScreen> createState() => _UserRoomsScreenState();
}

class _UserRoomsScreenState extends State<UserRoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Rooms'), actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              useSafeArea: true,
              builder: (ctx) => const AddRoomScreen(),
            );
          },
          icon: addIcon,
        )
      ]),
      body: ListView.builder(
        itemCount: dummyRooms.length,
        itemBuilder: (context, index) {
          return Hero(
            tag: dummyRooms[index].id,
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => RoomDetailsScreen(
                    room: dummyRooms[index],
                  ),
                ));
              },
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: bgIcon,
                ),
                child: const Icon(Icons.group),
              ),
              title: Text(
                dummyRooms[index].title.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: const Text(
                'Some description',
              ),
            ),
          );
        },
      ),
    );
  }
}
