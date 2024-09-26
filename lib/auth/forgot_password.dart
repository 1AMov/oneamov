import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common_functions/custom_toast.dart';
import '../dialog/error_dialog.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'auth_footer.dart';

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
  TextEditingController emailCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> submitEmail() async {
    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailCtrl.text.trim());

      showCustomToast("Password reset email sent.", type: "");

      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      showErrorDialog(context, e.toString());

      showCustomToast("An Error occurred :(", type: "error");
      setState(() {
        loading = false;
      });
    } catch (e) {
      showErrorDialog(context, e.toString());

      showCustomToast("An Error occurred :(", type: "error");
      setState(() {
        loading = false;
      });
    }
  }

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
          Text(
              "Don’t worry, happens to all of us. Enter your email below to recover your password",
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10.0),
          CustomTextField(
            controller: emailCtrl,
            enabled: !loading,
            labelText: "Email",
            hintText: "example@domain.com",
            textInputType: TextInputType.emailAddress,
            onChanged: (v) =>
                context.read<AuthStateProvider>().validateEmail(v),
            validator: (value) =>
                context.watch<AuthStateProvider>().emailErrorText,
          ),
          // BUTTON
          CustomButton(
              title: "Submit",
              loading: loading,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  submitEmail();
                } else {
                  showCustomToast("Fill the required field", type: "error");
                }
              }),
          const SizedBox(height: 30.0),
          const Align(alignment: Alignment.center, child: AuthFooter())
        ],
      ),
    );
  }
}
