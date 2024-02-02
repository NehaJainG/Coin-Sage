import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/icon.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({
    super.key,
    required this.userName,
  });
  final ColorProvider colors = ColorProvider();

  final String userName;

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
                    userName,
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
                      onTap: () {},
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
                onTap: () {},
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
                onTap: () {},
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
