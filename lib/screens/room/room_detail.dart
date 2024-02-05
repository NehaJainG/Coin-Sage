import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/services/room_repo.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/services/user_repo.dart';
import 'package:coin_sage/widgets/transaction/transaction_list.dart';
import 'package:coin_sage/models/room.dart';
import 'package:coin_sage/models/user.dart';
import 'package:coin_sage/defaults/colors.dart';

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
  bool isLoading = true;
  UserRepo userCollection = UserRepo();
  RoomRepositories roomCollection = RoomRepositories();

  List<User> _members = [];

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  void getMembers() async {
    setState(() {
      isLoading = true;
      _members = [];
    });
    if (widget.room.members == null) {
      return null;
    }
    for (String email in widget.room.members!) {
      final user = await userCollection.getUser(email);
      if (user != null) {
        setState(() {
          _members.add(user);
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.room.title), actions: [
        IconButton(
          onPressed: () {
            getMembers();
          },
          icon: refreshIcon,
        ),
      ]),
      body: StreamBuilder(
          stream: roomCollection.roomDB.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress;
            }
            return TransactionList(
                userTransactions: [],
                additionalContent: upperContent(),
                isDrawerOpen: false);
          }),
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
          child: StreamBuilder(
              stream: userCollection.userDB.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || isLoading) {
                  return circularProgress;
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _members.length,
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
                          (_members[index].name),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
