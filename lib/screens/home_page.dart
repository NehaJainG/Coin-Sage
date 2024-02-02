import 'package:flutter/material.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart' as cloud;

import 'package:coin_sage/screens/drawer.dart';
import 'package:coin_sage/screens/add_new_room.dart';
import 'package:coin_sage/screens/add_new_transaction.dart';
import 'package:coin_sage/screens/user_rooms.dart';
import 'package:coin_sage/screens/requests.dart';
import 'package:coin_sage/widgets/quick_buttons.dart';
import 'package:coin_sage/widgets/statistics.dart';
import 'package:coin_sage/widgets/transaction_list.dart';
import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/data/expense_list.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  final List<Transaction> userTransaction = transactionData;

  Widget get AppBar {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          isDrawerOpen
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      xOffset = 0;
                      yOffset = 0;
                      scaleFactor = 1;
                      isDrawerOpen = false;
                    });
                  },
                )
              : IconButton(
                  icon: menuIcon,
                  onPressed: () {
                    setState(() {
                      xOffset = size.width * 0.6;
                      yOffset = size.height * 0.125;
                      scaleFactor = 0.72;
                      isDrawerOpen = true;
                    });
                  },
                ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Neha',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
              ),
              Text(
                'Welcome :)',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 18,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addNewTransaction() async {
    final newTransaction = await Navigator.of(context).push<Transaction>(
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
    if (newTransaction == null) return;
    setState(() {
      userTransaction.add(newTransaction);
    });
  }

  void _addNewRoom() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      builder: (ctx) => const AddRoomScreen(),
    );
  }

  void _viewRooms() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => UserRoomsScreen(),
      ),
    );
  }

  void _viewRequests() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RequestScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget fixedContent = Container(
      child: SafeArea(
        child: Column(
          children: [
            AppBar,
            const SizedBox(height: 15),
            QuickButtons(
              newTransaction: _addNewTransaction,
              newRoom: _addNewRoom,
              allRooms: _viewRooms,
              viewRequest: _viewRequests,
            ),
            const SizedBox(height: 15),
            const TransactionStatistics(),
            const SizedBox(height: 30),
            const Divider(
              color: Colors.white,
              endIndent: 160,
              indent: 160,
              thickness: 3,
            )
          ],
        ),
      ),
    );

    return Scaffold(
      //backgroundColor: black,

      body: Stack(
        children: [
          DrawerScreen(userName: 'Neha Jain'),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor)
              ..rotateY(isDrawerOpen ? -0.5 : 0),
            duration: Duration(milliseconds: 250),
            child: TransactionList(
              userTransactions: userTransaction,
              additionalContent: fixedContent,
              isDrawerOpen: isDrawerOpen,
            ),
          ),
        ],
      ),
    );
  }
}
