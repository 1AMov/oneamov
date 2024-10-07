import 'package:flutter/material.dart';
import 'package:oneamov/config.dart';
import 'package:oneamov/helpers/text_styles.dart';
import 'package:oneamov/widgets/custom_button.dart';

class ToolAlertDialog extends StatelessWidget {
  final String? title;
  final String? text1;
  final String? text2;
  final String? text3;
  final String? text4;
  final String? btnText;
  final bool isActive;
  final void Function()? onPressed;
  const ToolAlertDialog(
      {super.key,
      this.title,
      this.text1,
      this.text2,
      this.text3,
      this.text4,
      this.btnText,
      this.onPressed, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      title: Text(
        title ?? "",
        style: const TextStyle(
            color: Config.lightBlueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Text(
            text1 ?? "",
            textAlign: TextAlign.center,
            style: context.dividerTextLarge?.copyWith(
                fontWeight: FontWeight.w800, color: Config.drawerColor),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            text2 ?? "",
            textAlign: TextAlign.center,
            style: context.titleText,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(text3 ?? ""),
          const SizedBox(
            height: 12,
          ),
          Text(
            text4 ?? "",
            style: context.dividerTextLarge?.copyWith(color: Config.greenColor),
          ),
          const SizedBox(
            height: 12,
          ),
          BorderButton(
              title: btnText ?? "",
              color: Config.themeColor,
              isActive: isActive,
              onPressed: onPressed!),
          const SizedBox(
            height: 12,
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"))
        ],
      ),
    );
  }
}

void showToolDialog(
    BuildContext context,
    String title,
    String text1,
    String text2,
    String text3,
    String text4,
    String btnText,
    bool isActive,
    void Function()? onPressed) {
  showDialog(
      context: context,
      builder: (context) {
        return ToolAlertDialog(
          title: title,
          text1: text1,
          text2: text2,
          text3: text3,
          text4: text4,
          btnText: btnText,
          onPressed: onPressed,
          isActive: isActive,
        );
      });
}
