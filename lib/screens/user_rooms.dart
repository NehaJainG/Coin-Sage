import 'package:flutter/material.dart';

import 'package:coin_sage/data/room_list.dart';
import 'package:coin_sage/assets/icon.dart';
import 'package:coin_sage/assets/defaults.dart';
import 'package:coin_sage/models/room.dart';
import 'package:coin_sage/models/user.dart';
import 'package:coin_sage/screens/add_new_room.dart';
import 'package:coin_sage/screens/room_detail.dart';

class UserRoomsScreen extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (int index = 0; index < dummyRooms.length; index++)
              RoomCard(
                index: index % darkcolorPalette.length,
                room: dummyRooms[index],
              )
          ],
        ),
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.room,
    required this.index,
  });

  final Room room;
  final int index;

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
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 10,
        ),
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
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                color: darkcolorPalette[index],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('date'),
                  const SizedBox(height: 6),
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
                  top: 20,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount'),
                    Text(
                      'Members:',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        for (User member in room.members)
                          Container(
                            padding: const EdgeInsets.only(right: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_circle,
                                  size: 30,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  member.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        fontSize: 18,
                                      ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
