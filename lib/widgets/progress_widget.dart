import 'package:flutter/material.dart';

import '../config.dart';

circularProgress({Color? color = Config.themeColor, double? size = 50.0}) {
  return Container(
    alignment: Alignment.center,
    height: size,
    width: size,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(color),
      strokeWidth: 2,
    ),
  );
}

linearProgress() {
  return Container(
    // alignment: Alignment.center,
    // padding: const EdgeInsets.only(top: 12.0),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Config.themeColor),
    ),
  );
}
