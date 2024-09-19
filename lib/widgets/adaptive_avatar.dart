import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class AdaptiveAvatar extends StatelessWidget {
  final double radius;
  final String photoUrl;
  final String name;
  final PlatformFile? file;

  const AdaptiveAvatar(
      {super.key,
      required this.radius,
      required this.photoUrl,
      required this.name,
      this.file});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Config.themeColor.withOpacity(0.4),
      backgroundImage: const AssetImage(Config.profileImage),
      radius: radius,
      foregroundImage: photoUrl == "" ? null : NetworkImage(photoUrl),
      child: file != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.memory(
                file!.bytes!,
                height: radius * 2,
                width: radius * 2,
                fit: BoxFit.cover,
              ),
            )
          : null,
    );
  }
}
