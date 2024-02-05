import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/icon.dart';

class HomeHeader extends StatelessWidget {
  HomeHeader({
    super.key,
    required this.newTransaction,
    required this.newRoom,
    required this.allRooms,
    required this.viewRequest,
  });

  final void Function() newTransaction;
  final void Function() newRoom;
  final void Function() allRooms;
  final void Function() viewRequest;
  final items = {
    'Transaction': addIcon,
    'Add Room': const Icon(Icons.group_add_rounded),
    'View Rooms': const Icon(Icons.groups),
    'Requests': const Icon(Icons.meeting_room_rounded),
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.entries.map((entry) {
            return Column(
              children: [
                Container(
                  height: 180,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: herodarkBlue,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: entry.value,
                    color: Colors.white,
                    onPressed: () {
                      if (entry.key == 'Transaction') {
                        newTransaction();
                      } else if (entry.key == 'Add Room') {
                        newRoom();
                      } else if (entry.key == 'View Rooms') {
                        allRooms();
                      } else if (entry.key == 'Requests') {
                        viewRequest();
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  entry.key,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.labelLarge,
                )
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Divider(
          color: Colors.white,
          endIndent: 160,
          indent: 160,
          thickness: 3,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
