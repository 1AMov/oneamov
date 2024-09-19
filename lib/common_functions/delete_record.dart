import 'package:flutter/material.dart';

import '../dialog/error_dialog.dart';
import '../widgets/custom_popup.dart';
import 'custom_toast.dart';

Future<void> deleteRecord(
    {required BuildContext context,
    required String title,
    required String description,
    required Future<String> Function() deleteFn}) async {
  // ignore: use_build_context_synchronously
  String result = await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return CustomPopup(
        title: title,
        isDanger: true,
        body: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 370.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(description),
          ),
        ),
        acceptTitle: "Delete",
        onAccepted: () => Navigator.pop(context, "proceed"),
        onCancel: () => Navigator.pop(context, "cancelled"),
      );
    },
  );
  if (result == "proceed") {
    try {
      showCustomToast("Deleting Data", type: "");

      String res = await deleteFn();

      if (res == "success") {
        showCustomToast("Record deleted successfully", type: "");
      }
    } catch (e) {
      print(e.toString());

      showErrorDialog(context, e.toString());

      showCustomToast("An Error Occurred :(", type: "error");
    }
  }
}
