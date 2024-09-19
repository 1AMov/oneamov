import 'package:flutter/material.dart';

import '../config.dart';

class CustomContainer extends StatelessWidget {
  // final EdgeInsetsGeometry? containerOutsidePadding;
  final EdgeInsetsGeometry? containerInsidePadding;
  final Color? color;
  final Widget child;

  const CustomContainer({
    super.key,
    // this.containerOutsidePadding = const EdgeInsets.all(10.0),
    this.containerInsidePadding =
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1),
        curve: Curves.fastOutSlowIn,
        padding: containerInsidePadding,
        width: size.width,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [Config.boxShadow],
        ),
        child: child,
      ),
    );
  }
}
