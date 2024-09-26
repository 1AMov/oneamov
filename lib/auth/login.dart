import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oneamov/auth/auth_footer.dart';
import 'package:oneamov/widgets/custom_textfield.dart';
import 'package:oneamov/widgets/custom_wrapper.dart';
import 'package:provider/provider.dart';

import '../common_functions/custom_toast.dart';
import '../config.dart';
import '../dialog/error_dialog.dart';
import '../models/account.dart';
import '../providers/auth_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/custom_button.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool showPassword = false;
  bool rememberMe = false;

  Future<void> proceedToDashboard(String userID, bool updateUserInfo) async {
    if (updateUserInfo) {
      await Config.usersCollection.doc(userID).update({
        // "rememberMe": rememberMe,
        "lastLogin": DateTime.now().millisecondsSinceEpoch
      });
    }

    setState(() {
      loading = false;
      emailCtrl.clear();
      passwordCtrl.clear();
      Provider.of<AuthStateProvider>(context, listen: false).resetTexts();
    });

    Timer(const Duration(seconds: 1), () {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentPage("home");

      GoRouter.of(context).go("/$userID/home?layout=flow");
    });
  }

  Future<void> loginUser() async {
    setState(() {
      loading = true;
    });

    try {
      QuerySnapshot querySnapshot = await Config.usersCollection
          .where("email", isEqualTo: emailCtrl.text.trim())
          // .where("password", isEqualTo: passwordCtrl.text.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Account userInfo = Account.fromDocument(querySnapshot.docs.first);

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text,
        );

        proceedToDashboard(userInfo.userID, true);
      } else {
        // No Such User

        showErrorDialog(context, 'No user found for that email.');

        showCustomToast('No user found for that email.', type: "error");

        setState(() {
          loading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');

        showErrorDialog(context, 'No user found for that email.');

        showCustomToast('No user found for that email.', type: "error");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showErrorDialog(context, "Wrong password provided for that user.");

        showCustomToast("Wrong password provided for that user.",
            type: "error");
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.toString());

      showErrorDialog(context, e.toString());

      showCustomToast("An Error occurred :(", type: "error");

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> workerLoginProcedure() async {}

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    // Provider.of<AuthStateProvider>(context, listen: false).resetTexts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Sign In",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.grey),
          ),
          const SizedBox(height: 10.0),
          CustomTextField(
            controller: emailCtrl,
            enabled: !loading,
            labelText: "Email Address",
            hintText: "example@domain.com",
            textInputType: TextInputType.emailAddress,
            onChanged: (v) =>
                context.read<AuthStateProvider>().validateEmail(v),
            validator: (value) =>
                value!.isEmpty ? 'Please enter an Email' : null,
            // context.watch<AuthStateProvider>().emailErrorText,
          ),
          CustomTextField(
            controller: passwordCtrl,
            enabled: !loading,
            obscureText: !showPassword,
            labelText: "Password",
            hintText: "password",
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              child: Icon(showPassword
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded),
            ),
            textInputType: TextInputType.visiblePassword,
            validator: (value) =>
                value!.isEmpty ? 'Please fill this field.' : null,
          ),
          const SizedBox(height: 10.0),
          const Text("Login with your email & password"),
          const SizedBox(height: 10.0),
          // BUTTON
          CustomWrapper(
            maxWidth: 300.0,
            child: BorderButton(
                title: "Sign In",
                isActive: true,
                color: Colors.grey,
                insidePadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    loginUser();
                  } else {
                    showCustomToast("Fill the required fields", type: "error");
                  }
                }),
          ),
          const SizedBox(height: 5.0),
          InkWell(
            onTap: () => context.go("/auth/forgot_password"),
            child: const Text(
              "Forgot Password",
              style: TextStyle(color: Config.themeColor),
            ),
          ),
          const SizedBox(height: 20.0),
          const Text(
            "OR",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20.0),
          CustomWrapper(
            maxWidth: 300.0,
            child: BorderButton(
                title: "Create Account",
                isActive: true,
                color: Colors.grey,
                insidePadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                onPressed: () {
                  context.go("/auth/signup");
                }),
          ),
          const SizedBox(height: 40.0),
          const AuthFooter()
        ],
      ),
    );
  }
}
