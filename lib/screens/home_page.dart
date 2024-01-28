import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;

import 'package:coin_sage/screens/add_new_room.dart';
import 'package:coin_sage/screens/add_new_transaction.dart';
import 'package:coin_sage/screens/user_rooms.dart';
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
  cloud.FirebaseFirestore? db;
  int _selectedPage = 0;
  final List<Transaction> userTransaction = transactionData;

  void login(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      print('made it');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  void initState() {
    login('nehajaing1324', 'neha12');
    super.initState();
  }

  void loadDB() {
    db = cloud.FirebaseFirestore.instance;
  }

  void _selectPage(int currentPageIndex) {
    //body
    setState(() {
      _selectedPage = currentPageIndex;
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

  @override
  Widget build(BuildContext context) {
    Widget fixedContent = Column(
      children: [
        QuickButtons(
          newTransaction: _addNewTransaction,
          newRoom: _addNewRoom,
          allRooms: _viewRooms,
        ),
        const Divider(),
        const SizedBox(height: 5),
        const TransactionStatistics(),
        const SizedBox(height: 15),
      ],
    );

    return Scaffold(
        //backgroundColor: black,
        drawer: const Drawer(),
        appBar: AppBar(
          title: const Text('Heyy Neha!'),
        ),
        body: TransactionList(
          userTransactions: userTransaction,
          additionalContent: fixedContent,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.onBackground,
          unselectedItemColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.60),
          iconSize: 26,
          currentIndex: _selectedPage,
          onTap: _selectPage,
          items: [
            BottomNavigationBarItem(
              //tooltip: 'home',
              label: '.',
              icon: homeIcon,
              activeIcon: homeActive,
            ),
            BottomNavigationBarItem(
              label: '.',
              icon: statistic,
              activeIcon: statisticActive,
            ),
            BottomNavigationBarItem(
              label: '.',
              icon: chat,
              activeIcon: chatActive,
            ),
            BottomNavigationBarItem(
              label: '.',
              icon: setting,
              activeIcon: settingActive,
            ),
          ],
        ));
  }
}


// Expanded(
//             child: Column(
//               children: [
//                 QuickButtons(
//                   newTransaction: _addNewTransaction,
//                   newRoom: _addNewRoom,
//                   allRooms: _viewRooms,
//                 ),
//                 const Divider(),
//                 const SizedBox(height: 5),
//                 const TransactionStatistics(),
//                 const SizedBox(height: 15),
//                 Expanded(
//                   child: TransactionList(
//                     userTransactions: transactionData,
//                   ),
//                 ),