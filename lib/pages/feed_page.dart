import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oneamov/config.dart';
import 'package:oneamov/helpers/text_styles.dart';
import 'package:oneamov/models/love_icons.dart';
import 'package:oneamov/models/post.dart';
import 'package:oneamov/models/project_sector.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FeedPage extends StatefulWidget {
  final String userID;
  const FeedPage({super.key, required this.userID});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool loading = false;
  List<Post> posts = [];
  List<LoveIcons> loveIcons = [
    LoveIcons(color: Colors.blue, image: Config.thumbWhite, onPressed: () {}),
    LoveIcons(
        color: Config.themeColor, image: Config.loveWhite, onPressed: () {})
  ];

  // Future<QuerySnapshot> getPosts() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   try {
  //     QuerySnapshot querySnapshot =
  //         await FirebaseFirestore.instance.collection("posts").get();
  //     for (var doc in querySnapshot.docs) {
  //       Post post = Post.fromDocument(doc);

  //       posts.add(post);
  //     }
  //     setState(() {
  //       loading = false;
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   throw "An error occured";
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isMobile =
            sizingInformation.isMobile || sizingInformation.isTablet;
        return Column(
          children: [
            Container(
              margin: !isMobile
                  ? const EdgeInsets.symmetric(horizontal: 30)
                  : const EdgeInsets.all(0),
              height: size.height * 0.4,
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
              decoration: const BoxDecoration(color: Colors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Latest videos",
                    style: context.titleText?.copyWith(
                        color: Config.themeColor, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: projectSectors.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0, top: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    projectSectors[index].imageUrl,
                                    height: 200,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                      top: 4,
                                      right: 4,
                                      left: 4,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            decoration: const BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black54,
                                                      offset: Offset(2, 3),
                                                      spreadRadius: 2,
                                                      blurRadius: 2)
                                                ],
                                                color: Config.themeColor,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        Config.userPlaceholder),
                                                    fit: BoxFit.cover)),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.more_vert,
                                                  color: Colors.white))
                                        ],
                                      )),
                                  Positioned(
                                      bottom: 4,
                                      child: Text(
                                        "---------------\n--------------\n---------------",
                                        style: context.dividerTextLarge
                                            ?.copyWith(color: Colors.white),
                                      ))
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: projectSectors.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0, top: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    projectSectors[index].imageUrl,
                                    height: 200,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                      top: 4,
                                      right: 4,
                                      left: 4,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            decoration: const BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black54,
                                                      offset: Offset(2, 3),
                                                      spreadRadius: 2,
                                                      blurRadius: 2)
                                                ],
                                                color: Config.themeColor,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        Config.userPlaceholder),
                                                    fit: BoxFit.cover)),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.more_vert,
                                                  color: Colors.white))
                                        ],
                                      )),
                                  Positioned(
                                      bottom: 4,
                                      child: Text(
                                        "----------------\n----------------\n-------------------",
                                        style: context.dividerTextLarge
                                            ?.copyWith(color: Colors.white),
                                      ))
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: size.height,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("posts").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      
                      snapshot.data!.docs.forEach((element) {
                        Post post = Post.fromDocument(element);
                        posts.add(post);
                      });
                      return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            Post post = posts[index];
                            return Container(
                              margin: !isMobile
                                  ? const EdgeInsets.symmetric(horizontal: 30)
                                  : const EdgeInsets.all(0),
                              padding: !isMobile
                                  ? const EdgeInsets.symmetric(horizontal: 30)
                                  : const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundImage: AssetImage(
                                              Config.userPlaceholder),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              post.title,
                                              style: context.bodyLarge
                                                  ?.copyWith(
                                                      color:
                                                          Colors.black),
                                            ),
                                            Text(
                                              post.description,
                                              style: context.bodyLarge
                                                  ?.copyWith(
                                                      color:
                                                          Config.drawerColor),
                                            ),
                                            Text(
                                              post.description,
                                              style: context.bodyLarge
                                                  ?.copyWith(
                                                      color:
                                                          Config.drawerColor),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Image.asset(Config.country)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post.footer,
                                                style: context.bodySmall
                                                    ?.copyWith(
                                                        color:
                                                            Config.drawerColor),
                                              ),
                                              Text(
                                                post.link,
                                                style: context.bodySmall
                                                    ?.copyWith(
                                                        color:
                                                            Config.lightBlueColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Image.asset(
                                              Config.buttonArrow,
                                              // width: 70,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Stack(children: [
                                    !isMobile
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                                    child: post.imageUrls.isNotEmpty? Image.network(post.imageUrls.first) : const SizedBox.shrink(),
                                            // child: Image.network(post
                                            //         .imageUrls.isNotEmpty
                                            //     ? post.imageUrls.first
                                            //     : "https://cdn.pixabay.com/photo/2023/12/22/12/30/trees-8463651_1280.png"),
                                          ): post.imageUrls.isNotEmpty? Image.network(post.imageUrls.first) : const SizedBox.shrink(),
                                        // : Image.network(post
                                        //         .imageUrls.isNotEmpty
                                        //     ? post.imageUrls.first
                                        //     : "https://cdn.pixabay.com/photo/2023/12/22/12/30/trees-8463651_1280.png"),
                                    Positioned(
                                        bottom: 10,
                                        right: 6,
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: Image.asset(
                                              Config.addPhoto,
                                              width: 100,
                                            )))
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            for (int i = 0;
                                                i < loveIcons.length;
                                                i++)
                                              Align(
                                                widthFactor: 0.5,
                                                child: IconButton(
                                                    onPressed:
                                                        loveIcons[i].onPressed,
                                                    icon: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: loveIcons[i]
                                                              .color,
                                                        ),
                                                        child: Image.asset(
                                                            loveIcons[i]
                                                                .image))),
                                              ),
                                              SizedBox(width: 5,),
                                            Text("${post.interactions.loves}"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: Image.asset(
                                                  Config.commentGrey,
                                                  width: 30,
                                                )),
                                            Text(
                                                "${post.interactions.comments}"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: Image.asset(
                                                  Config.eyeGrey,
                                                  width: 30,
                                                )),
                                            Text("${post.interactions.likes}"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("${post.interactions.shares}"),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Image.asset(
                                                  Config.shareGrey,
                                                  width: 30,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Image.asset(
                                            Config.thumbgrey,
                                            // width: 70,
                                          )),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Image.asset(
                                            Config.loveBlack,
                                            // width: 70,
                                          )),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Image.asset(
                                            Config.commentBlack,
                                            // width: 70,
                                          )),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.more_vert,
                                            
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    }))
          ],
        );
      },
    );
  }
}
