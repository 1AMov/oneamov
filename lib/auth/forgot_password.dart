import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    super.key,
  });

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
          CustomBackButton(
            title: "Back to Login",
            onPressed: () => context.go("/auth/login"),
          ),
          Text(
            "Forgot Your Password?",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10.0),
          // Implement YOur User Interface here
        ],
      ),
    );
  }
}
