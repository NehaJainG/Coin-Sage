import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/icon.dart';
import 'package:flutter/material.dart';

class AppBar extends StatelessWidget {
  const AppBar({
    super.key,
    required this.name,
    required this.isDrawerOpen,
    required this.openDrawer,
    required this.closeDrawer,
    required this.onRefresh,
  });

  final String name;
  final bool isDrawerOpen;
  final void Function() closeDrawer;
  final void Function() openDrawer;
  final void Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: black,
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
}
