import 'package:coin_sage/defaults/defaults.dart';
import 'package:flutter/material.dart';

class QuickButtons extends StatelessWidget {
  QuickButtons({
    super.key,
    required this.newTransaction,
    required this.newRoom,
    required this.allRooms,
  });

  //void  sample () {}
  final void Function() newTransaction;
  final void Function() newRoom;
  final void Function() allRooms;
  final items = {
    'Transaction': const Icon(Icons.add),
    'Add Room': const Icon(Icons.group_add_rounded),
    'View Rooms': const Icon(Icons.groups),
    'View Room': const Icon(Icons.groups),
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.entries.map((entry) {
        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: black,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.blue,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: IconButton(
                icon: entry.value,
                onPressed: () {
                  if (entry.key == 'Transaction') {
                    newTransaction();
                  } else if (entry.key == 'Add Room') {
                    newRoom();
                  } else if (entry.key == 'View Rooms') {
                    allRooms();
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
    );
  }
}
