import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  final String userID;
  const FeedPage({super.key, required this.userID});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [Text("User Feed comes here")],
    );
  }
}
