import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/colors.dart';

InputDecoration inputDecor(
    String label, Icon? prefixIcon, String? prefixText, String? hintText) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 20,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    labelText: label,
    prefixIcon: prefixIcon,
    prefixText: prefixText,
    hintText: hintText,
  );
}

FloatingActionButton exitButton(BuildContext context) => FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      backgroundColor: Colors.white10,
      splashColor: Colors.white38,
      elevation: 0,
      mini: true,
      tooltip: 'Tap to exit',
      child: const Icon(
        Icons.close_rounded,
        color: Colors.black,
        size: 30,
      ),
    );

Widget btwVertical = const SizedBox(height: 10);
EdgeInsetsGeometry dePadding = const EdgeInsets.all(10);
EdgeInsetsGeometry listMargin = const EdgeInsets.symmetric(horizontal: 6);
double nFormPadding = 30;

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

bool isNotValidTitle(String title) {
  return title.isEmpty || title.length > 25;
}

//valid amount verification
bool isNotValidAmt(String? amt) {
  if (amt == null || amt.isEmpty) return true;
  double? amount = double.tryParse(amt);
  if (amount == null || amount <= 0) {
    return true;
  }
  return false;
}

Widget circularProgress = const Center(
  child: CircularProgressIndicator(),
);

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(message,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.white,
              )),
      backgroundColor: heroBlue.withOpacity(0.7),
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

Map<int, String> months = {
  01: 'Jan',
  02: 'Feb',
  03: 'Mar',
  04: 'Apr',
  05: 'May',
  06: 'June',
  07: 'July',
  08: 'Aug',
  09: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};
