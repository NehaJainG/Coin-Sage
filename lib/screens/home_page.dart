import 'package:coin_sage/screens/reminders.dart';
import 'package:flutter/material.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart' as cloud;

import 'package:coin_sage/screens/drawer.dart';
import 'package:coin_sage/screens/add_new_room.dart';
import 'package:coin_sage/screens/add_new_transaction.dart';
import 'package:coin_sage/screens/user_rooms.dart';
import 'package:coin_sage/screens/requests.dart';
import 'package:coin_sage/widgets/home_page_header.dart';
import 'package:coin_sage/widgets/transaction_list.dart';
import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/data/expense_list.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  final List<Transaction> userTransaction = transactionData;

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  void openDrawer() {
    Size size = MediaQuery.of(context).size;
    setState(() {
      xOffset = size.width * 0.6;
      yOffset = size.height * 0.125;
      scaleFactor = 0.72;
      isDrawerOpen = true;
    });
  }

  Widget get AppBar {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          isDrawerOpen
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: closeDrawer,
                )
              : IconButton(
                  icon: menuIcon,
                  onPressed: openDrawer,
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

  Widget get fixedContent {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(50),
          top: Radius.circular(isDrawerOpen ? 20 : 0),
        ),
        boxShadow: [
          BoxShadow(
            color: lightGrey.withOpacity(0.7),
            blurRadius: 3,
          )
        ],
        color: blackBlue,
      ),
      child: SafeArea(
        child: Column(
          children: [
            AppBar,
            HomeHeader(
              newTransaction: _addNewTransaction,
              newRoom: _addNewRoom,
              allRooms: _viewRooms,
              viewRequest: _viewRequests,
            ),
          ],
        ),
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
        builder: (ctx) => const Scaffold(
              backgroundColor: Colors.transparent,
              body: AddRoomScreen(),
            ));
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

  Widget viewReminders() {
    return Reminders(
      appBar: AppBar,
    );
  }

  Widget homePage() {
    return TransactionList(
      userTransactions: userTransaction,
      additionalContent: fixedContent,
      isDrawerOpen: isDrawerOpen,
    );
  }

  void selectPage(value) {
    setState(() {
      _selectedPage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(
            userName: 'Neha Jain',
            selectPage: selectPage,
            closeDrawer: closeDrawer,
            transaction: _addNewTransaction,
            room: _viewRooms,
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor)
              ..rotateY(isDrawerOpen ? -0.5 : 0),
            duration: Duration(milliseconds: 250),
            child: _selectedPage == 0 ? homePage() : Reminders(appBar: AppBar),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: selectPage,
        items: [
          BottomNavigationBarItem(
            icon: home,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: reminderIcon,
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: settings,
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
