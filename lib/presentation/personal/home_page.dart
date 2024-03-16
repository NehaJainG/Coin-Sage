import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:coin_sage/defaults/icon.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/strings.dart';

import 'package:coin_sage/models/transaction.dart';

import 'package:coin_sage/presentation/personal/drawer.dart';
import 'package:coin_sage/presentation/personal/settings.dart';
import 'package:coin_sage/presentation/rooms/user_rooms.dart';
import 'package:coin_sage/presentation/rooms/requests.dart';
import 'package:coin_sage/presentation/rooms/room.dart';
import 'package:coin_sage/presentation/transaction/add_transaction.dart';
import 'package:coin_sage/presentation/transaction/transaction_list.dart';
import 'package:coin_sage/presentation/reminders/reminders.dart';

import 'package:coin_sage/services/reminders.dart';
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

  Map<String, double> userStats = {
    'Income': 0,
    'Expense': 0,
    'Reminders': 0,
  };

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
    getStats();
  }

  void getStats() async {
    final double count =
        await ReminderServices.getUserNoOfReminder(widget.user.uid);

    final expense = userTransaction
        .map<double>((transaction) {
          double amount = 0.0;
          if (transaction.type != TransactionType.Income) {
            amount = transaction.amount;
          }
          return amount;
        })
        .toList()
        .fold(0.0, (previousValue, element) => previousValue + element);

    final income = userTransaction
        .map((transaction) {
          double amount = 0.0;
          if (transaction.type == TransactionType.Income) {
            amount = transaction.amount;
          }
          return amount;
        })
        .toList()
        .fold(0.0, (previousValue, element) => previousValue + element);

    setState(() {
      userStats['Reminders'] = count;
      userStats['Income'] = income;
      userStats['Expense'] = expense;
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

  Widget stats(
    String title,
    String value,
    Color? foreground,
    Color? borderColor,
    double width,
    Icon? icon,
    Color? textColor,
  ) {
    return Container(
      width: width,
      height: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: foreground,
        borderRadius: BorderRadius.circular(10),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              icon ?? const SizedBox(),
              const SizedBox(width: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                    ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
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
    double width = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: lightGrey.withOpacity(0.7),
            blurRadius: 3,
          )
        ],
        color: blackBlue,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        height: 280,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Your Stats',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 20,
                      ),
                ),
                const Spacer(),
                const Icon(Icons.bar_chart_rounded),
              ],
            ),
            const SizedBox(height: 10),
            stats('Total Expense', '$rupee ${userStats['Expense']}', BG, null,
                width * 0.9, const Icon(Icons.currency_exchange), red),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                stats('Total Income', '$rupee ${userStats['Income']}', BG, null,
                    width * 0.43, iconList[TransactionType.Income]!, green),
                const Spacer(),
                stats('Reminders', '${userStats['Reminders']!.ceil()}', null,
                    BG, width * 0.43, null, null),
              ],
            ),
            const Spacer(),
            Divider(
              thickness: 3,
              color: white,
              indent: width * 0.4,
              endIndent: width * 0.4,
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
      appBar: AppBar(getTransaction),
      isDrawerOpen: isDrawerOpen,
    );
  }

  Widget viewReminders() {
    return Reminders(
      appBar: AppBar,
      isDrawerOpen: isDrawerOpen,
      user: widget.user,
    );
  }

  Widget settingPage() {
    return SettingPage(
      user: widget.user,
      appBar: AppBar(null),
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
      floatingActionButton: _selectedPage == 0
          ? !isDrawerOpen
              ? FloatingActionButton.extended(
                  backgroundColor: BG,
                  onPressed: _addNewTransaction,
                  label: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                )
              : null
          : null,
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
              child: _selectedPage == 0
                  ? homePage()
                  : _selectedPage == 1
                      ? viewReminders()
                      : settingPage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDrawerOpen ? BG : null,
        currentIndex: _selectedPage,
        onTap: selectPage,
        items: [
          BottomNavigationBarItem(
            icon: home,
            activeIcon: homeActive,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: reminderIcon,
            activeIcon: reminderActive,
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: settings,
            activeIcon: settingActive,
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
