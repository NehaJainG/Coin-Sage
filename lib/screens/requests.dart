import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/models/room.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<Room>? roomRequest;

  void acceptRequest(Room room, int index) {
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
                  roomRequest![index].title,
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
            onPressed: () {},
          ),
        ],
      ),
      body: content,
    );
  }
}
