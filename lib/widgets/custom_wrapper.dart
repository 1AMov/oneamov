import 'package:flutter/material.dart';

class CustomWrapper extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const CustomWrapper({
    super.key,
    required this.maxWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );
  }
}
