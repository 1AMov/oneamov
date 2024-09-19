import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../config.dart';

class CustomScrollBar extends StatelessWidget {
  final Widget? child;
  final ScrollController? controller;
  final double? width;
  const CustomScrollBar(
      {super.key,
      required this.child,
      required this.controller,
      this.width = Config.scrollbarWidth});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isMobile = sizingInformation.isMobile;

        return RawScrollbar(
          controller: controller,
          thumbVisibility: !isMobile,
          trackVisibility: !isMobile,
          radius: const Radius.circular(0.0),
          thumbColor: Colors.grey.shade500,
          trackColor: Colors.grey.shade200,
          thickness: isMobile ? Config.scrollbarWidthMobile : width,
          child: child!,
        );
      },
    );
  }
}
