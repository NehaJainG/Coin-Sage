import 'package:coin_sage/defaults/colors.dart';
import 'package:flutter/material.dart';

class Reminders extends StatelessWidget {
  const Reminders({
    super.key,
    required this.appBar,
  });

  final Widget appBar;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: black,
              blurRadius: 30,
            ),
          ]),
      child: Column(
        children: [
          appBar,
          Container(
            padding: const EdgeInsets.fromLTRB(0, 300, 0, 0),
            child: Text(
              'Not yet',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      ),
    );
  }
}
