import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class NotificationsCountFetcher extends StatelessWidget {
  const NotificationsCountFetcher({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Config.notificationsCollection
          .where("isRead", isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          int count = snapshot.data!.docs.length;

          return count == 0
              ? const SizedBox()
              : CircleAvatar(
                  radius: 10.0,
                  backgroundColor: Colors.pink,
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 10.0),
                    ),
                  ));
        }
      },
    );
  }
}
