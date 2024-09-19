import 'package:flutter/material.dart';

import '../config.dart';
import 'custom_button.dart';

class CustomPopup extends StatefulWidget {
  final String title;
  final Widget body;
  final bool? isDanger;
  final String acceptTitle;
  final String? cancelTitle;
  final void Function() onCancel;
  final void Function() onAccepted;

  const CustomPopup({
    super.key,
    required this.title,
    required this.body,
    this.isDanger = false,
    required this.acceptTitle,
    this.cancelTitle = "CANCEL",
    required this.onAccepted,
    required this.onCancel,
  });

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      // contentPadding: EdgeInsets.zero,
      content: widget.body,
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(
            widget.cancelTitle!,
            style: TextStyle(
                color: widget.isDanger! ? Colors.black : Config.themeColor),
          ),
        ),
        CustomButton(
          onPressed: widget.onAccepted,
          title: widget.acceptTitle,
          loading: false,
          isTight: true,
          color: widget.isDanger! ? Colors.red : Config.themeColor,
        )
      ],
    );
  }
}

class OptionsPopup extends StatelessWidget {
  final String? title;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? body;
  const OptionsPopup({super.key, this.title, this.contentPadding, this.body});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: contentPadding,
      title: title == null
          ? null
          : Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
      content: body,
    );
  }
}

class ErrorPopup extends StatelessWidget {
  final String? title;
  final Widget? body;
  const ErrorPopup({super.key, this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title!,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w800),
      ),
      content: body,
      actions: [
        CustomButton(
          onPressed: () => Navigator.pop(context),
          title: "Close",
          loading: false,
          isTight: true,
        )
      ],
    );
  }
}
