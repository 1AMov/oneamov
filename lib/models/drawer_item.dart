import 'package:flutter/material.dart';

class DrawerItem {
  String id;
  String title;
  IconData? iconData;
  String? secondIcon;
  final List<String> roles;

  DrawerItem(
      {required this.id,
      required this.title,
      this.iconData,
      this.secondIcon,
      required this.roles});
}

List<DrawerItem> drawerItems = [
  DrawerItem(
      id: 'feed',
      title: 'Feed',
      iconData: Icons.home_rounded,
      roles: ['admin', 'user']),
];
