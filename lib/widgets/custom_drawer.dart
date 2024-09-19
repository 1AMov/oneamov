import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oneamov/providers/base_ui_provider.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/account.dart';
import '../models/drawer_item.dart';
import '../providers/navigation_provider.dart';
import 'notifications_count_fetcher.dart';

class CustomDrawer extends StatefulWidget {
  final String userID;
  final bool isMobile;
  const CustomDrawer(
      {super.key, required this.userID, required this.isMobile});

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
    return Icon(
      drawerItem.iconData,
      color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
    );
  }

  List<DrawerItem> filteredDrawerItems(String role) {
    return drawerItems.where((e) => e.roles.contains(role)).toList();
  }

  Widget drawerItemWidget(Size size, DrawerItem drawerItem,
      String selectedDrawerItem, bool isDrawerShrink) {
    bool isSelected = selectedDrawerItem == drawerItem.id;

    bool isNotification = drawerItem.id == 'notifications';
    bool isSettings = drawerItem.id == "settings";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isSettings) ...[
          const SizedBox(height: 10.0),
          Container(
            width: size.width,
            height: 1.0,
            color: Colors.white54,
          ),
          const SizedBox(height: 10.0),
        ],
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
                        ? Colors.white.withOpacity(0.1)
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
                            return Colors.white.withOpacity(0.1);
                          }
                          return Colors.transparent;
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
                          ? Colors.white.withOpacity(0.1)
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
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.7)),
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
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0)),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String selectedDrawerItem = context.watch<NavigationProvider>().currentPage;
    bool isDrawerShrink = context.watch<BaseUIProvider>().isDrawerShrink;

    // TextStyle textStyle = Theme.of(context).textTheme.titleLarge!;

    return Drawer(
      backgroundColor: Config.drawerColor,
      child: StreamBuilder<DocumentSnapshot>(
          stream: Config.usersCollection.doc(widget.userID).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              Account account = Account.fromDocument(snapshot.data!);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          Config.logoWhite,
                          height: isDrawerShrink ? 40.0 : 80.0,
                          width: isDrawerShrink ? 40.0 : 80.0,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2.5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: Colors.white)),
                          child: Text(
                            account.role.toUpperCase(),
                            style: TextStyle(
                                fontSize: isDrawerShrink ? 8.0 : 10.0,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                              filteredDrawerItems(account.role).length,
                              (index) {
                            DrawerItem drawerItem =
                                filteredDrawerItems(account.role)[index];
                            return drawerItemWidget(size, drawerItem,
                                selectedDrawerItem, isDrawerShrink);
                          }),
                        ),
                      ),
                    ),
                    Text(
                      isDrawerShrink
                          ? Config.version
                          : "Version: ${Config.version}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
