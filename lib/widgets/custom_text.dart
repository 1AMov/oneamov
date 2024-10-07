import 'package:flutter/material.dart';
import 'package:oneamov/helpers/text_styles.dart';

class CustomHeadingText extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const CustomHeadingText({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          text,
          style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
