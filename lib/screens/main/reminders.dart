import 'package:coin_sage/defaults/colors.dart';
import 'package:flutter/material.dart';

class Reminders extends StatelessWidget {
  const Reminders({
    super.key,
    required this.appBar,
    required this.isDrawerOpen,
  });

  final bool isDrawerOpen;
  final Widget appBar;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: black,
            blurRadius: 30,
          ),
        ],
        borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
      ),
      child: SafeArea(
        child: Column(
          children: [
            appBar,
          ],
        ),
      ),
    );
  }
}
