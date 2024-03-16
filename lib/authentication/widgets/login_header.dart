import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.header,
    required this.imagePath,
  });

  final String header;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    //double heigth = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          imagePath,
          width: 400,
        ),
        Text(
          header,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 40,
              ),
        ),
      ],
    );
  }
}
