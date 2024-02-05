import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/services/room_repo.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/screens/addnew/room.dart';
import 'package:coin_sage/screens/room/room_detail.dart';

import 'package:coin_sage/models/room.dart';

import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/colors.dart';

class UserRoomsScreen extends StatefulWidget {
  @override
  State<UserRoomsScreen> createState() => _UserRoomsScreenState();
}

class _UserRoomsScreenState extends State<UserRoomsScreen> {
  bool isLoading = true;
  RoomRepositories roomCollection = RoomRepositories();
  List<Room> userRooms = [];
  Future getRoomList() async {
    //initial setup whenever loading data
    setState(() {
      isLoading = true;
    });
    userRooms = [];

    //fetching data here
    final rooms = await roomCollection.getRooms();

    //reflecting data to ui here
    if (rooms != null) {
      setState(() {
        userRooms.addAll(rooms);
      });
    }
    isLoading = false;
  }

  @override
  void initState() {
    getRoomList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        'You haven\'t joined nor created Rooms.',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
    if (userRooms.isNotEmpty) {
      content = ListView.builder(
        itemCount: userRooms.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => RoomDetailsScreen(
                  room: userRooms[index],
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
              userRooms[index].title.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: const Text(
              'Some description',
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Rooms'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                useSafeArea: true,
                builder: (ctx) => AddRoomScreen(),
              );
            },
            icon: addIcon,
          ),
          IconButton(
            onPressed: () {
              getRoomList();
            },
            icon: refreshIcon,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: roomCollection.roomDB.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || isLoading) {
              return circularProgress;
            }
            return content;
          }),
    );
  }
}
