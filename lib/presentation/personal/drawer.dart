import 'package:flutter/material.dart';

import 'package:coin_sage/authentication/firebase_auth/firebase_auth_servies.dart';
import 'package:coin_sage/authentication/screens/login.dart';
import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/icon.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    super.key,
    required this.userName,
    required this.closeDrawer,
    required this.transaction,
    required this.room,
    required this.selectPage,
    required this.requests,
  });
  final String userName;
  final void Function() closeDrawer;
  final void Function() transaction;
  final void Function() room;
  final void Function(int) selectPage;
  final void Function() requests;

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final ColorProvider colors = ColorProvider();

  void signOut() {
    final auth = FirebaseAuthService();
    auth.logout();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BG,
      padding: const EdgeInsets.only(top: 50, bottom: 50, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                maxRadius: 30,
                child: person,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: colors.widgetColors['bg'],
                    ),
                  ),
                  Text(
                    'Active Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.widgetColors['bg'],
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: drawerItems.entries
                .map((element) => ListTile(
                      onTap: () {
                        widget.closeDrawer();
                        if (element.key == 'Add Transaction') {
                          widget.transaction();
                        } else if (element.key == 'View Rooms') {
                          widget.room();
                        } else if (element.key == 'Home') {
                          widget.selectPage(0);
                        } else if (element.key == 'Reminder') {
                          widget.selectPage(1);
                        } else if (element.key == 'Requests') {
                          widget.requests();
                        }
                      },
                      title: Text(
                        element.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      leading: element.value,
                      iconColor: colors.widgetColors['bg'],
                      textColor: colors.widgetColors['bg'],
                    ))
                .toList(),
          ),
          Column(
            children: [
              ListTile(
                onTap: signOut,
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: logoutIcon,
                iconColor: red,
                textColor: red,
              ),
              const SizedBox(width: 40),
            ],
          )
        ],
      ),
    );
  }
}
