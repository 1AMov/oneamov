import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common_functions/custom_toast.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String? message;
  const ErrorAlertDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      title: const Text(
        "ERROR",
        style: TextStyle(color: Colors.red),
      ),
      content: SelectableText(
        message!,
        style: const TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message!)).then((value) =>
                  showCustomToast("Error copied to clipboard", type: ""));
            },
            label: const Text(
              "Copy",
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(
              Icons.copy,
              color: Colors.black,
            )),
        TextButton.icon(
            onPressed: () => Navigator.pop(context),
            label: const Text(
              "Close",
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.black,
            )),
      ],
    );
  }
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ErrorAlertDialog(
          message: message,
        );
      });
}
