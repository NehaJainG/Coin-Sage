import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/services/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:coin_sage/presentation/reminders/reminders.dart';
import 'package:coin_sage/presentation/rooms/user_rooms.dart';
import 'package:coin_sage/presentation/rooms/requests.dart';
import 'package:coin_sage/presentation/transaction/add_transaction.dart';
import 'package:coin_sage/presentation/rooms/room.dart';

import 'package:coin_sage/presentation/personal/drawer.dart';
import 'package:coin_sage/presentation/transaction/transaction_list.dart';

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
    print('before');
    List<Transaction>? list =
        await TransactionRepository.getTransactions(widget.user.uid);
    if (list == null) {
      return;
    }
    userTransaction = [];
    print('after');
    setState(() {
      userTransaction.addAll(list);
      userTransaction.sort((a, b) => b.date.compareTo(a.date));
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
        builder: (context) => const AddTransactionScreen(),
      ),
    );
    if (newTransaction == null) return;

    setState(() {
      userTransaction.add(newTransaction);
    });

    await TransactionRepository.addTransaction(newTransaction, widget.user.uid);
    showSnackBar("Transaction is added successfully", context);
    getTransaction();
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
      user: widget.user,
    );
  }

  Widget AppBar(void Function()? onRefresh) {
    name = widget.user.displayName ?? 'User';
    name = name.split(' ')[0];
    return Container(
      decoration: BoxDecoration(
        color: blackBlue,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isDrawerOpen ? 20 : 0),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Text(
              'Heyy $name',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onRefresh,
              icon: refreshIcon,
            ),
          ],
        ),
      ),
    );
  }

  Widget get fixedContent {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: lightGrey.withOpacity(0.7),
            blurRadius: 3,
          )
        ],
        color: blackBlue,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: TextButton(
              onPressed: () {
                PushNotifications.createNotification(
                  DateTime.now().add(
                    const Duration(minutes: 1),
                  ),
                );
              },
              child: const Text('Check notification'),
            ),
          ),
        ],
      ),
    );
  }

  Widget homePage() {
    return TransactionList(
      userTransactions: userTransaction,
      additionalContent: fixedContent,
      appBar: AppBar(getTransaction),
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
              requests: _viewRequests,
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
