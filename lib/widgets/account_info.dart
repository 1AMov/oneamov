import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../config.dart';
import '../models/account.dart';
import 'adaptive_avatar.dart';

class AccountInfo extends StatelessWidget {
  final String userID;
  const AccountInfo({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // bool isMobile = sizingInformation.isMobile;

        return StreamBuilder<DocumentSnapshot>(
          stream: Config.usersCollection.doc(userID).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              Account account = Account.fromDocument(snapshot.data!);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          account.userName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          account.role.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Config.themeColor,
                                  fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(width: 5.0),
                    AdaptiveAvatar(
                        radius: 16.0,
                        photoUrl: account.photoUrl,
                        name: account.userName)
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}

class TableUserInfo extends StatelessWidget {
  final bool isAdmin;
  final String photoUrl;
  final String title;
  final String subtitle;
  const TableUserInfo(
      {super.key,
      required this.isAdmin,
      required this.photoUrl,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AdaptiveAvatar(radius: 12.0, photoUrl: photoUrl, name: title),
        const SizedBox(width: 5.0),
        Expanded(
          child: isAdmin
              ? Text(
                  "ADMIN",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 5.0),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ]
                  ],
                ),
        )
      ],
    );
  }
}
