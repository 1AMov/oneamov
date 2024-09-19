import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../widgets/custom_popup.dart';

Future<void> getVersion(BuildContext context) async {
  DocumentSnapshot doc =
      await Config.maintenanceCollection.doc("maintenance").get();

  String version = doc["version"];

  if (version != Config.version) {
    await showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: Config.isDebugMode,
      builder: (context) {
        return OptionsPopup(
            contentPadding: EdgeInsets.zero,
            // title: ,
            body: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Config.themeColor,
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(3.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 30.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.update_rounded,
                            color: Colors.white,
                            size: 80.0,
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            "V $version",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "New Version Available!",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 20.0),
                          SelectableText(
                              "The version you are using is outdated. Refresh the page to get the latest version: $version. Your version is ${Config.version}"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
