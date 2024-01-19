import 'package:flutter/material.dart';

import 'package:coin_sage/models/room.dart';

class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.title),
      ),
    );
  }
}
