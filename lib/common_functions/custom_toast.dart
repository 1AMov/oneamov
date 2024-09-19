import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showCustomToast(String msg, {required String type}) {
  bool isError = type == "error";
  String color = isError ? "#B71C1C" : "#212B36";

  Fluttertoast.showToast(
    msg: msg,
    webShowClose: true,
    timeInSecForIosWeb: 10,
    textColor: Colors.white,
    webBgColor: "linear-gradient(to right, $color, $color)",
  );
}
