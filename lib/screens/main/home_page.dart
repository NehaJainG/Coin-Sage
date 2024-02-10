import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:coin_sage/screens/main/reminders.dart';
import 'package:coin_sage/screens/room/user_rooms.dart';
import 'package:coin_sage/screens/room/requests.dart';
import 'package:coin_sage/screens/addnew/transaction.dart';
import 'package:coin_sage/screens/addnew/room.dart';

import 'package:coin_sage/widgets/home/drawer.dart';
import 'package:coin_sage/widgets/home/home_page_header.dart';
import 'package:coin_sage/widgets/transaction/transaction_list.dart';

import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/colors.dart';

import 'package:coin_sage/services/transaction_repo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TransactionRepository transactionRepo = TransactionRepository();

  int _selectedPage = 0;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  bool isLoading = false;

  List<Transaction> userTransaction = [];

  late String name;

  @override
  void initState() {
    getTransaction();
    super.initState();
  }

  void getTransaction() async {
    isLoading = true;
    userTransaction = [];

    List<Transaction>? list =
        await transactionRepo.getTransactions(widget.user.uid);
    if (list == null) {
      return;
    }

    setState(() {
      userTransaction.addAll(list);
      isLoading = false;
    });
  }

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

  void _addNewTransaction() async {
    final newTransaction = await Navigator.of(context).push<Transaction>(
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(user: widget.user),
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
      builder: (ctx) => AddRoomScreen(user: widget.user),
    );
  }

  void _viewRooms() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => UserRoomsScreen(user: widget.user),
      ),
    );
  }

  void _viewRequests() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RequestScreen(user: widget.user)),
    );
  }

  Widget viewReminders() {
    return Reminders(
      appBar: AppBar,
      isDrawerOpen: isDrawerOpen,
    );
  }

  Widget get AppBar {
    name = widget.user.displayName ?? 'User';
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Row(
        children: [
          isDrawerOpen
              ? IconButton(
                  icon: backIcon,
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
                'Welcome',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 18,
                    ),
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: getTransaction,
            icon: refreshIcon,
          ),
        ],
      ),
    );
  }

  Widget get fixedContent {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: const Radius.circular(50),
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
      body: GestureDetector(
        child: Stack(
          children: [
            DrawerScreen(
              userName: widget.user.displayName ?? "User",
              selectPage: selectPage,
              closeDrawer: closeDrawer,
              transaction: _addNewTransaction,
              room: _viewRooms,
            ),
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)
                ..rotateY(isDrawerOpen ? -0.5 : 0),
              duration: const Duration(milliseconds: 250),
              child: _selectedPage == 0 ? homePage() : viewReminders(),
            ),
          ],
        ),
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
