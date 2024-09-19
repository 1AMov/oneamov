import 'dart:convert';

import 'package:flutter/services.dart';

Future<dynamic> readJson(String file) async {
  final String response = await rootBundle.loadString(file);
  final data = await json.decode(response);

  return data;
}
