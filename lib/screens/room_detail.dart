import 'package:flutter/material.dart';

import 'package:coin_sage/widgets/transaction_list.dart';
import 'package:coin_sage/models/room.dart';
import 'package:coin_sage/defaults/colors.dart';

import 'package:coin_sage/data/expense_list.dart';

class RoomDetailsScreen extends StatefulWidget {
  const RoomDetailsScreen({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.title),
      ),
      body: TransactionList(
          userTransactions: transactionData,
          additionalContent: upperContent(),
          isDrawerOpen: false),
    );
  }

  Widget upperContent() {
    return Column(
      children: [
        const Divider(),
        memberList(),
        const Divider(),
      ],
    );
  }

  Widget memberList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 5),
          child: Text(
            'Members',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
          ),
        ),
        Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.room.members.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.fromLTRB(20, 8, 8, 8),
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: lightGrey.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                  ),
                  Text(
                    widget.room.members[index].name,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
