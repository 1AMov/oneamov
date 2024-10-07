import 'package:flutter/material.dart';
import 'package:oneamov/config.dart';
import 'package:oneamov/helpers/text_styles.dart';
import 'package:oneamov/models/project_sector.dart';

class SectorChoosing extends StatefulWidget {
  const SectorChoosing({super.key});

  @override
  State<SectorChoosing> createState() => _SectorChoosingState();
}

class _SectorChoosingState extends State<SectorChoosing> {
  late ScrollController controller;
  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1A Project Sectors:",
                    style: context.titleLarge
                        ?.copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    "Click item to change sector for your post",
                    style: context.bodyLarge?.copyWith(
                        color: Config.drawerColor, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    Config.x,
                    width: 50,
                  ))
            ],
          ),
          const Divider(
            thickness: 2,
          ),
          Expanded(
            child: Scrollbar(
                controller: controller,
                //thumbVisibility: true,
                //trackVisibility: true,
                interactive: true,
                //radius: Radius.circular(20),
                //thickness: 20,
                child: ListView.builder(
                    itemCount: projectSectors.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${(index + 1).toString().padLeft(2, "0")}.",
                                  style: context.titleText,
                                ),
                                const SizedBox(width: 20.0),
                                Image.asset(
                                  Config.setting,
                                  width: 90,
                                ),
                               
                                Expanded(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Text(
                                        projectSectors[index].title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            wordSpacing: 1.5),
                                      ),
                                    ),
                                    const SizedBox(height: 18.0),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.asset(
                                        projectSectors[index].imageUrl,
                                        height: 100.0,
                                        width: 170,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Divider(
                              thickness: 1.5,
                            ),
                          ],
                        ),
                      );
                    })),
          )
        ],
      ),
    );
  }
}

void showScectorListings(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
            maxChildSize: 0.97,
            initialChildSize: 0.83,
            expand: false,
            builder: (context, scrollController) {
              return const SectorChoosing();
            });
      });
}
