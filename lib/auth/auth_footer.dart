import 'package:flutter/material.dart';
import 'package:oneamov/config.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "The 1A Project",
          style:
              TextStyle(fontWeight: FontWeight.w700, color: Config.themeColor),
        ),
        SizedBox(height: 10.0),
        Text(
          "Contact Us",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 20.0),
        Text(
          "Privacy Policy | Terms",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 30.0),
        Text("1AMov \u00a9 2024")
      ],
    );
  }
}
