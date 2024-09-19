import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common_functions/custom_toast.dart';
import '../config.dart';
import '../dialog/error_dialog.dart';
import '../widgets/custom_button.dart';

class EmailVerificationPage extends StatefulWidget {
  final void Function() onVerified;
  const EmailVerificationPage({super.key, required this.onVerified});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _timer;
  Timer? _continuousTimer;
  // starting value for countdown
  ValueNotifier<int> _start = ValueNotifier<int>(59);

  @override
  void initState() {
    super.initState();

    sendEmailVerification();
  }

  Future<void> sendEmailVerification() async {
    setState(() {
      loading = true;
    });
    try {
      await _auth.currentUser!.sendEmailVerification();

      _start = ValueNotifier<int>(59);

      startTimer();

      showCustomToast("Email Sent", type: "");

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

  void continuousTimer() {
    _continuousTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _auth.currentUser!.reload();
      if (_auth.currentUser!.emailVerified) {
        widget.onVerified();
      }
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_start.value == 0) {
          timer.cancel();

          continuousTimer();
        } else {
          _start.value--;
          if (_start.value % 5 == 0) {
            await _auth.currentUser!.reload();
            if (_auth.currentUser!.emailVerified) {
              widget.onVerified();
            }
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _continuousTimer?.cancel();
    _start.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Config.mailSentImage,
                width: 300.0,
                height: 300.0,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20.0),
              Text(
                "Verify Your Email Address",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Config.themeColor),
              ),
              const SizedBox(height: 10.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: <TextSpan>[
                    const TextSpan(text: "We have sent an email to "),
                    TextSpan(
                        text: _auth.currentUser!.email,
                        style: const TextStyle(
                            color: Config.themeColor,
                            fontWeight: FontWeight.bold)),
                    const TextSpan(
                        text: ". Click on the link to verify your account.")
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              ValueListenableBuilder<int>(
                valueListenable: _start,
                builder: (context, value, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '00:$value s',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 20.0),
                      CustomButton(
                          title: "Resend Email",
                          isTight: true,
                          isActive: value == 0,
                          loading: loading,
                          onPressed: () => sendEmailVerification())
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
