import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.header,
    required this.subMessage,
  });

  final String header;
  final String subMessage;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: width * 0.2),
        Text(
          header,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
        ),
        Text(
          subMessage,
          maxLines: 2,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
