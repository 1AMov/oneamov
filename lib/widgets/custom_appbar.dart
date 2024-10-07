import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oneamov/pages/new_post.dart';
import 'package:oneamov/widgets/adaptive_avatar.dart';
import 'package:oneamov/widgets/custom_button.dart';
import 'package:oneamov/widgets/notifications_count_fetcher.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../config.dart';
import '../models/account.dart';

class CustomAppbar extends StatefulWidget {
  final String userID;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppbar(
      {super.key, required this.userID, required this.scaffoldKey});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isMobile =
            sizingInformation.isMobile || sizingInformation.isTablet;

        return Padding(
          padding: EdgeInsets.all(isMobile ? 0.0 : 10.0),
          child: Container(
            // height: kTextTabBarHeight,
            width: size.width,
            constraints: const BoxConstraints(minHeight: kToolbarHeight),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isMobile ? 0.0 : 10.0),
                color: Colors.white,
                boxShadow: [Config.boxShadow]),
            child: StreamBuilder<DocumentSnapshot>(
                stream: Config.usersCollection.doc(widget.userID).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  Account account = Account.fromDocument(snapshot.data!);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (isMobile) {
                                    widget.scaffoldKey.currentState!
                                        .openDrawer();
                                  }
                                },
                                child: AdaptiveAvatar(
                                    radius: 17.0,
                                    photoUrl: account.photoUrl,
                                    name: account.userName)),
                            if (isMobile) ...[
                              Image.asset(
                                Config.logo,
                                height: 35.0,
                                width: 35.0,
                                fit: BoxFit.contain,
                              )
                            ],
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.home,
                                      color: Config.themeColor,
                                    )),
                                Stack(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.notifications_active_outlined,
                                          color: Colors.grey,
                                        )),
                                    const Positioned(
                                        top: 5.0,
                                        right: 5.0,
                                        child: NotificationsCountFetcher())
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                      if (!isMobile) ...[
                        Container(
                          width: size.width,
                          height: 1.0,
                          color: Colors.grey.shade200,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                      postsActionItems.length, (index) {
                                    // return IconButton(
                                    //     onPressed: () {},
                                    //     icon: Icon(
                                    //       postsActionItems[index].iconData,
                                    //       color: Colors.grey,
                                    //     ));
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: InkWell(
                                        onTap:
                                            postsActionItems[index].onPressed,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              postsActionItems[index].iconData,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              postsActionItems[index].title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              CustomButton(
                                  title: "Post",
                                  loading: false,
                                  isTight: true,
                                  onPressed: () {
                                    GoRouter.of(context)
                                        .go("/${widget.userID}/new_post");
                                  })
                            ],
                          ),
                        )
                      ]
                    ],
                  );
                }),
          ),
        );
      },
    );
  }
}

class PostActionItem {
  String id;
  String title;
  IconData iconData;
  void Function() onPressed;

  PostActionItem(
      {required this.id,
      required this.title,
      required this.iconData,
      required this.onPressed});
}

List<PostActionItem> postsActionItems = [
  PostActionItem(
      id: "images",
      title: "Images",
      iconData: Icons.photo_library_outlined,
      onPressed: () {}),
  PostActionItem(
      id: "videos",
      title: "Videos",
      iconData: Icons.play_circle_outline_rounded,
      onPressed: () {}),
  PostActionItem(
      id: "pdf",
      title: "PDF",
      iconData: Icons.picture_as_pdf_outlined,
      onPressed: () {}),
  PostActionItem(
      id: "audio",
      title: "Audio",
      iconData: Icons.volume_up_rounded,
      onPressed: () {}),
];
