import 'package:flutter/material.dart';

import '../config.dart';

class OptionWidget extends StatelessWidget {
  final String? title;
  final List<Widget> contents;
  final bool value;
  final void Function(bool?) onChanged;
  const OptionWidget(
      {super.key,
      this.title,
      required this.contents,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          title == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          activeColor: Config.themeColor,
          onChanged: onChanged,
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  title!,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5.0),
              ],
              ...contents,
            ],
          ),
        )
      ],
    );
  }
}
