import 'package:flutter/material.dart';
import '../config.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key,});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign Up",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Config.themeColor),
          ),
          const SizedBox(height: 10.0),
          // Implement Your User Interface here
        ],
      ),
    );
  }
}
