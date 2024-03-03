import 'package:firebase_auth/firebase_auth.dart' as fs;
import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/colors.dart';

import 'package:coin_sage/services/room_repo.dart';
import 'package:coin_sage/services/user_repo.dart';
import 'package:coin_sage/presentation/transaction/transaction_list.dart';
import 'package:coin_sage/presentation/transaction/add_transaction.dart';
import 'package:coin_sage/models/room.dart';
import 'package:coin_sage/models/user.dart';
import 'package:coin_sage/models/transaction.dart';

class RoomDetailsScreen extends StatefulWidget {
  const RoomDetailsScreen({
    super.key,
    required this.room,
    required this.user,
  });

  final Room room;
  final fs.User user;

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  bool isLoading = true;

  List<User> _members = [];
  List<Transaction> roomTransaction = [];
  Map<String, double> statsVal = {
    'Total Cost': 0,
    'My Costs': 0,
    'You Owe': 0,
  };

  @override
  void initState() {
    getMembers();
    getTransaction();
    getStats();
    super.initState();
  }

  void getStats() async {
    final data =
        await RoomRepositories.getStats(widget.room.id!, widget.user.email!);
    if (data.values.isEmpty) return;
    print('stats');
    setState(() {
      statsVal = data;
    });
  }

  void _addNewTransaction() async {
    final newTransaction = await Navigator.of(context).push<Transaction>(
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
    if (newTransaction == null) return;
    print(newTransaction);
    setState(() {
      print('here');
      roomTransaction.add(newTransaction);
    });
    print(newTransaction);
    await RoomRepositories.addTransactionToRoom(
        newTransaction, widget.room.id!, widget.user.email!);
  }

  void getTransaction() async {
    List<Transaction>? list = await RoomRepositories.getRoomTransactions(
        widget.room.id!, widget.room.members!);
    if (list == null) return;
    roomTransaction = [];
    setState(() {
      roomTransaction.addAll(list);
    });
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
      final user = await UserRepo.getUser(email);
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
      body: StreamBuilder(
          stream: RoomRepositories.roomDB.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress;
            }
            return TransactionList(
                userTransactions: roomTransaction,
                additionalContent: upperContent(),
                appBar: AppBar(
                  title: Text(widget.room.title),
                  actions: [
                    IconButton(
                      icon: addIcon,
                      onPressed: _addNewTransaction,
                    ),
                    IconButton(
                      onPressed: () {
                        getTransaction();
                        getStats();
                      },
                      icon: refreshIcon,
                    ),
                  ],
                ),
                isDrawerOpen: false);
          }),
    );
  }

  Widget upperContent() {
    double width = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        const SizedBox(height: 15),
        stats('Total Cost', statsVal['Total Cost']!.round().toString(), navy,
            null, width - 20),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            stats('My Costs', statsVal['My Costs']!.round().toString(),
                heroBlue, null, width * 0.5 - 15),
            stats('You Owe', statsVal['You Owe']!.round().toString(), null,
                lightBlue, width * 0.5 - 15),
          ],
        ),
        const SizedBox(height: 15),
        memberList(),
      ],
    );
  }

  Widget stats(
    String title,
    String value,
    Color? foreground,
    Color? borderColor,
    double width,
  ) {
    return Container(
      width: width,
      height: 90,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: foreground,
        borderRadius: BorderRadius.circular(10),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget memberList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0, 8, 5),
          child: Row(
            children: [
              Text(
                'Members',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: refreshIcon,
                onPressed: () {
                  getMembers();
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: StreamBuilder(
              stream: UserRepo.userDB.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || isLoading) {
                  return circularProgress;
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _members.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 8, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          child: Icon(Icons.person_2),
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
