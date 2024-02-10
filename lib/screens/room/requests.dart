import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:coin_sage/services/user_repo.dart';
import 'package:coin_sage/services/room_repo.dart';
import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/models/room.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  RoomRepositories roomRepo = RoomRepositories();
  UserRepo userRepo = UserRepo();

  List<Room>? roomRequest;
  bool isLoading = false;

  @override
  void initState() {
    getRequests();
    super.initState();
  }

  void getRequests() async {
    setState(() {
      isLoading = true;
    });
    print(widget.user.email);
    final requests = await roomRepo.getRoomsRequests(widget.user.email!);
    setState(() {
      roomRequest = requests;
      isLoading = false;
    });
  }

  void acceptRequest(Room room, int index) {
    userRepo.addRoomId(widget.user.email!, room.id!);
    userRepo.removeRequestId(widget.user.email!, room.id!);
    setState(() {
      roomRequest!.remove(room);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('You are added into room ${room.title}.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              roomRequest!.insert(index, room);
            });
          },
        ),
      ),
    );
  }

  void declineRequest(Room room, int index) {
    userRepo.removeRequestId(widget.user.email!, room.id!);
    setState(() {
      roomRequest!.remove(room);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('You declined to join room ${room.title}.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              roomRequest!.insert(index, room);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        'Werid. No Requests found...',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w400,
            ),
      ),
    );
    if (roomRequest != null && roomRequest!.isNotEmpty) {
      content = ListView.separated(
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Text(
                  roomRequest![index].title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    acceptRequest(roomRequest![index], index);
                  },
                  icon: Icon(
                    Icons.done,
                    color: green,
                  ),
                  label: Text(
                    'Accept',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: green,
                        ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    declineRequest(roomRequest![index], index);
                  },
                  icon: Icon(
                    Icons.close,
                    color: red,
                  ),
                  label: Text(
                    'Decine',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: red,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (ctx, index) {
          return Divider(
            thickness: 3,
            endIndent: 8,
            indent: 8,
            color: lightBlue.withOpacity(0.6),
          );
        },
        itemCount: roomRequest!.length,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        actions: [
          IconButton(
            icon: refreshIcon,
            onPressed: getRequests,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: roomRepo.roomDB.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show circular progress while loading
            return circularProgress;
          } else if (!snapshot.hasData || snapshot.data!.size == 0) {
            // Show a message when no data exists
            return content;
          } else {
            // Show your content when data is available
            return content;
          }
        },
      ),
    );
  }
}
