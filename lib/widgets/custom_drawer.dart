import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oneamov/providers/base_ui_provider.dart';
import 'package:oneamov/widgets/adaptive_avatar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../config.dart';
import '../models/account.dart';
import '../models/drawer_item.dart';
import '../providers/navigation_provider.dart';
import 'notifications_count_fetcher.dart';

class CustomDrawer extends StatefulWidget {
  final String userID;
  final bool isMobile;
  const CustomDrawer({super.key, required this.userID, required this.isMobile});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  void onPressed(BuildContext context, String id) {
    context.read<NavigationProvider>().setCurrentPage(id);

    context.go("/${widget.userID}/$id");

    if (widget.isMobile) {
      Timer(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }

  Widget iconBuilder(DrawerItem drawerItem, bool isSelected) {
    bool iconIsNull = drawerItem.iconData == null;

    return iconIsNull
        ? Image.asset(
            drawerItem.secondIcon!,
            width: 30.0,
            height: 30.0,
            fit: BoxFit.contain,
          )
        : Icon(
            drawerItem.iconData,
            color: isSelected ? Config.themeColor : Colors.grey,
          );
  }

  // List<DrawerItem> filteredDrawerItems(String role) {
  //   return drawerItems.where((e) => e.roles.contains(role)).toList();
  // }

  Widget drawerItemWidget(Size size, DrawerItem drawerItem,
      String selectedDrawerItem, bool isDrawerShrink) {
    bool isSelected = selectedDrawerItem == drawerItem.id;

    bool isNotification = drawerItem.id == 'notifications';
    // bool isSettings = drawerItem.id == "settings";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // if (isSettings) ...[
        //   const SizedBox(height: 10.0),
        //   Container(
        //     width: size.width,
        //     height: 1.0,
        //     color: Colors.white54,
        //   ),
        //   const SizedBox(height: 10.0),
        // ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Stack(
            children: [
              if (isDrawerShrink) ...[
                Container(
                  // padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: isSelected
                        ? Config.themeColor.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: IconButton(
                      tooltip: drawerItem.title,
                      onPressed: () => onPressed(context, drawerItem.id),
                      isSelected: isSelected,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Config.themeColor.withOpacity(0.1);
                          }
                          return Colors.grey;
                        }),
                      ),
                      icon: iconBuilder(drawerItem, isSelected)),
                ),
                if (isNotification) ...[
                  const Positioned(
                    left: 20,
                    top: 5.0,
                    // bottom: 0.0,
                    child: NotificationsCountFetcher(),
                  )
                ]
              ] else ...[
                InkWell(
                  onTap: () => onPressed(context, drawerItem.id),
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: isSelected
                          ? Config.themeColor.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            iconBuilder(drawerItem, isSelected),
                            const SizedBox(width: 15.0),
                            Text(
                              drawerItem.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .apply(
                                      color: isSelected
                                          ? Config.themeColor
                                          : Colors.grey),
                            )
                          ],
                        ),
                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Container(
                        //       height: 25.0,
                        //       width: 3.0,
                        //       decoration: BoxDecoration(
                        //           color: isSelected
                        //               ? Colors.white
                        //               : Colors.transparent,
                        //           borderRadius: BorderRadius.circular(10.0)),
                        //     ),
                        //     const SizedBox(width: 1.0)
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
                // ListTile(
                //   selected: isSelected,
                //   selectedTileColor: Colors.white.withOpacity(0.1),
                //   style: ListTileStyle.drawer,
                //   onTap: () => onPressed(context, drawerItem.id),
                //   leading: iconBuilder(drawerItem, isSelected),
                //   title: Text(
                //     drawerItem.title,
                //     style: Theme.of(context).textTheme.titleSmall!.apply(
                //         color: isSelected
                //             ? Colors.white
                //             : Colors.white.withOpacity(0.7)),
                //   ),
                // ),
                // Positioned(
                //   right: 0,
                //   top: 0,
                //   bottom: 0,
                //   child: Container(
                //     // height: 40.0,
                //     width: 3.0,
                //     color: isSelected ? Colors.white : Colors.transparent,
                //   ),
                // ),
                if (isNotification) ...[
                  const Positioned(
                    left: 30,
                    top: 5.0,
                    // bottom: 0.0,
                    child: NotificationsCountFetcher(),
                  )
                ],
              ],
              Positioned(
                  right: 0,
                  top: 8,
                  bottom: 8,
                  child: Container(
                    // height: 25.0,
                    width: 3.0,
                    decoration: BoxDecoration(
                        color:
                            isSelected ? Config.themeColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0)),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget drawerDivider(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Container(
        width: size.width,
        height: 1.0,
        color: Colors.grey.shade200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String selectedDrawerItem = context.watch<NavigationProvider>().currentPage;
    bool isDrawerShrink = context.watch<BaseUIProvider>().isDrawerShrink;

    // TextStyle textStyle = Theme.of(context).textTheme.titleLarge!;

    return ResponsiveBuilder(builder: (context, sizingInfo) {
      bool isDesktop = sizingInfo.isDesktop;

      return SizedBox(
        height: isDesktop ? 600.0 : double.infinity,
        child: Drawer(
          elevation: 0.0,
          backgroundColor: isDesktop
              ? Colors.transparent
              : Theme.of(context).scaffoldBackgroundColor,
          child: StreamBuilder<DocumentSnapshot>(
              stream: Config.usersCollection.doc(widget.userID).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  Account account = Account.fromDocument(snapshot.data!);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isDesktop) ...[
                          Image.asset(
                            Config.logo,
                            height: isDrawerShrink ? 40.0 : 60.0,
                            width: isDrawerShrink ? 40.0 : 60.0,
                            fit: BoxFit.contain,
                          ),
                        ] else ...[
                          AdaptiveAvatar(
                              radius: 30.0,
                              photoUrl: account.photoUrl,
                              name: account.userName)
                        ],
                        const SizedBox(height: 20.0),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            "Feed Layout",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        drawerItemWidget(
                            size,
                            DrawerItem(
                                id: "home?layout=grid",
                                title: "Grid",
                                iconData: Icons.grid_view,
                                roles: ["admin", "users"]),
                            selectedDrawerItem,
                            isDrawerShrink),
                        drawerItemWidget(
                            size,
                            DrawerItem(
                                id: "home?layout=flow",
                                title: "Flow",
                                iconData: Icons.view_list_outlined,
                                roles: ["admin", "users"]),
                            selectedDrawerItem,
                            isDrawerShrink),
                        drawerItemWidget(
                            size,
                            DrawerItem(
                                id: "home?layout=mixed",
                                title: "Mixed",
                                iconData: Icons.view_quilt_outlined,
                                roles: ["admin", "users"]),
                            selectedDrawerItem,
                            isDrawerShrink),
                        drawerDivider(size),
                        drawerItemWidget(
                            size,
                            DrawerItem(
                                id: "1a_project",
                                title: "1A Project",
                                secondIcon: Config.logo,
                                roles: ["admin", "users"]),
                            selectedDrawerItem,
                            isDrawerShrink),
                        if (!isDesktop) ...[
                          drawerItemWidget(
                              size,
                              DrawerItem(
                                  id: "new_post",
                                  title: "Post",
                                  iconData: Icons.photo_camera,
                                  roles: ["admin", "users"]),
                              selectedDrawerItem,
                              isDrawerShrink),
                        ],
                        drawerItemWidget(
                            size,
                            DrawerItem(
                                id: "shop",
                                title: "Shop",
                                iconData: Icons.shopping_bag_outlined,
                                roles: ["admin", "users"]),
                            selectedDrawerItem,
                            isDrawerShrink),
                        drawerItemWidget(
                            size,
                            DrawerItem(
                                id: "stakehold",
                                title: "Stakehold",
                                iconData: Icons.trending_up_rounded,
                                roles: ["admin", "users"]),
                            selectedDrawerItem,
                            isDrawerShrink),
                        drawerItemWidget(
                            size,
                            DrawerItem(
                                id: "contact_us",
                                title: "Contact Us",
                                iconData: Icons.alternate_email_rounded,
                                roles: ["admin", "users"]),
                            selectedDrawerItem,
                            isDrawerShrink),
                        drawerDivider(size),
                        drawerItemWidget(
                            size,
                            DrawerItem(
                                id: "settings",
                                title: "Settings",
                                iconData: Icons.settings_outlined,
                                roles: ["admin", "users"]),
                            selectedDrawerItem,
                            isDrawerShrink),
                        drawerDivider(size),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: isDesktop
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "1AMov \u00a9 2024",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Privacy"),
                                SizedBox(width: 5.0),
                                Icon(
                                  Icons.circle,
                                  size: 8.0,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 5.0),
                                Text("Terms"),
                              ],
                            )
                          ],
                        )
                        // Text(
                        //   isDrawerShrink
                        //       ? Config.version
                        //       : "Version: ${Config.version}",
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .bodySmall!
                        //       .copyWith(color: Colors.white),
                        // )
                      ],
                    ),
                  );
                }
              }),
        ),
      );
    });
  }
}
