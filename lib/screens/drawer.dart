import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/icon.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen({
    super.key,
    required this.userName,
    required this.closeDrawer,
    required this.transaction,
    required this.room,
    required this.selectPage,
  });
  final String userName;
  final void Function() closeDrawer;
  final void Function() transaction;
  final void Function() room;
  final void Function(int) selectPage;

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final ColorProvider colors = ColorProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: herodarkBlue.withOpacity(0.7),
      padding: const EdgeInsets.only(top: 50, bottom: 50, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: person,
                maxRadius: 30,
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
                        if (element.key == 'Transaction') {
                          widget.transaction();
                        } else if (element.key == 'All Rooms') {
                          widget.room();
                        } else if (element.key == 'Home') {
                          widget.selectPage(0);
                        } else if (element.key == 'Reminder') {
                          widget.selectPage(1);
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
                onTap: () {
                  widget.closeDrawer();
                },
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: settings,
                iconColor: colors.widgetColors['bg'],
                textColor: colors.widgetColors['bg'],
              ),
              ListTile(
                onTap: () {
                  widget.closeDrawer();
                },
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
            ],
          )
        ],
      ),
    );
  }
}
