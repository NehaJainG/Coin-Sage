import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/colors.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({
    required this.user,
    required this.appBar,
    required this.isDrawerOpen,
    super.key,
  });

  final User user;
  final Widget appBar;
  final bool isDrawerOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: black,
            blurRadius: 30,
          ),
        ],
        borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appBar,
          const Text('Settings'),
          const Spacer(),
          Text(
            'In next version',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
