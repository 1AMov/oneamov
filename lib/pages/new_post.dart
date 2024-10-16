import 'dart:async';
import 'dart:html' as html;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:video_player/video_player.dart';

import 'package:oneamov/common_functions/custom_file_picker.dart';
import 'package:oneamov/common_functions/custom_toast.dart';
import 'package:oneamov/config.dart';
import 'package:oneamov/dialog/error_dialog.dart';
import 'package:oneamov/helpers/text_styles.dart';
import 'package:oneamov/models/attach_files.dart';
import 'package:oneamov/models/post.dart';
import 'package:oneamov/models/project_sector.dart';
import 'package:oneamov/pages/sector_choosing.dart';
import 'package:oneamov/widgets/custom_button.dart';
import 'package:oneamov/widgets/custom_text.dart';
import 'package:oneamov/widgets/custom_textfield.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController headingController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController footerController = TextEditingController();
  TextEditingController linkTextController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  late List<AttachFiles> attachFiles;
  // Boolean variables to control visibility
  bool showHeadingField = false;
  bool showFooterField = false;
  bool showLinkFields = false;
  //Checkbox boolean variables
  bool unPublish = false;
  bool reply = false;
  bool badge = false;
  bool loading = false;
  List<dynamic> imagePaths = [];
  List<String> documentPaths = [];
  List<int> size = [];
  List<PlatformFile>? pickedImages;
    VideoPlayerController? _videoPlayerController;
  File? _videoFile;
  Uint8List? _videoBytes;
   String? _videoUrl;
    AudioPlayer _audioPlayer = AudioPlayer();
  File? _audioFile;
  String? _audioUrl;
  Uint8List? _audioBytes;
   Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;
   bool _isAudioSelected = false;


    Future<void> _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
      withData: kIsWeb,
    );

    if (result != null) {
          setState(() {
        _isAudioSelected = true; 
      });
      if (kIsWeb) {
        setState(() {
          _audioBytes = result.files.single.bytes;
        });

        // Create a blob URL for the web
        final blob = html.Blob([_audioBytes!]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        setState(() {
          _audioUrl = url;
        });

        // Set the audio player to play from the URL
        await _audioPlayer.setUrl(_audioUrl!);
      } else {
        // Handle native platforms (mobile/desktop)
        setState(() {
          _audioFile = File(result.files.single.path!);
        });

        // Set the audio player to play from the file
        await _audioPlayer.setFilePath(_audioFile!.path);
      }

      // Listen to audio duration and position changes
      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _audioDuration = duration ?? Duration.zero;
        });
      });

      _positionSubscription = _audioPlayer.positionStream.listen((position) {
        setState(() {
          _audioPosition = position;
        });
      });
    }
  }

    Widget buildProgressBar() {
    return Slider(
      value: _audioPosition.inSeconds.toDouble(),
      max: _audioDuration.inSeconds.toDouble(),
      onChanged: (value) async {
        await _audioPlayer.seek(Duration(seconds: value.toInt()));
      },
    );
  }

  // Method to pick video using FilePicker
   Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video, // Specify the file type as video
      allowMultiple: false,
      withData: kIsWeb, // On the web, you will need the video as bytes
    );

    if (result != null) {
      if (kIsWeb) {
        // Handle video for web by creating a blob URL
        setState(() {
          _videoBytes = result.files.single.bytes;
        });

        final blob = html.Blob([_videoBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        setState(() {
          _videoUrl = url;
        });

        _videoPlayerController = VideoPlayerController.network(_videoUrl!)
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController!.play();
          });
      } else {
        // If not on web, use the file path
        setState(() {
          _videoFile = File(result.files.single.path!);
        });

        _videoPlayerController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController!.play();
          });
      }
    }
  }

  Future<List<dynamic>> selectImages() async {
    List<PlatformFile> selectedImages =
        await CustomFilePicker.pickImages(isMultiple: false);

    if (selectedImages.isNotEmpty) {
      // Return the file paths or names of the selected images
      if (kIsWeb) {
        setState(() {
          imagePaths = selectedImages.map((file) => file).toList();
        });
      } else {
        setState(() {
          imagePaths = selectedImages.map((file) => file).toList();
        });
      }
      print("${imagePaths}");
      return imagePaths;
    } else {
      return [];
    }
  }

  Future selectImage() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image, withData: true);
    if (result == null) return;
    setState(() {
      pickedImages = result.files;
    });
  }

  Future uploadImages(List<PlatformFile> files) async {
    List<String> downloadUrls = [];
    for (var file in files) {
      if (file.bytes != null) {
        // Define the storage path for each image
        final storageRef = FirebaseStorage.instance.ref().child(
            'post_images/${DateTime.now().millisecondsSinceEpoch}_${file. bytes}');

        // Upload the image as a byte stream
        final uploadTask = storageRef.putData(file.bytes!);

        // Wait for the upload to complete and get the download URL
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
    }

    return downloadUrls;
  }

  Future<List<String>> selectDocuments() async {
    List<PlatformFile> selectedDocuments = await CustomFilePicker.pickDocuments(
      isMultiple: true,
      fileType: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (selectedDocuments.isNotEmpty) {
      size = selectedDocuments.map((file) => file.size).toList();
      // Return the file paths or names of the selected documents
      if (kIsWeb) {
        documentPaths =
            selectedDocuments.map((file) => file.xFile.path).toList();
      } else {
        documentPaths = selectedDocuments.map((file) => file.path!).toList();
      }
      print("documant name is: ${documentPaths}");
      return documentPaths;
    } else {
      return [];
    }
  }

  Future<void> createPost() async {
    setState(() {
      loading = true;
    });
    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      User? currentUser = FirebaseAuth.instance.currentUser;
      String userId = currentUser?.uid ?? "";
      List<String> imageUrls = [];
      if (pickedImages != null && pickedImages!.isNotEmpty) {
        imageUrls = await uploadImages(pickedImages!); // Upload selected images
      }
      Post post = Post(
          postID: timestamp.toString(),
          title: headingController.text.trim(),
          description: bodyController.text.trim(),
          footer: footerController.text.trim(),
          tags: [],
          hashTags: [],
          postType: "free",
          price: 0,
          currency: "KES",
          sector: {},
          publisherId: userId,
          link: linkController.text.trim(),
          linkText: linkTextController.text.trim(),
          imageUrls: imageUrls,
          videoUrls: [],
          documents: Documents(name: documentPaths, pages: [], size: size),
          fundraise: false,
          fundraiseData: Fundraiser(
              target: "",
              fundraiserId: "",
              userId: "",
              amount: 0,
              currency: "KES",
              timestamp: timestamp),
          interactions:
              Interactions(likes: 0, loves: 0, shares: 0, comments: 0),
          timeStamp: timestamp);

      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.postID)
          .set(post.toMap());
      showCustomToast("Your post has successfully been uploaded",
          type: "Success");
      headingController.clear();
      bodyController.clear();
      footerController.clear();
      linkController.clear();
      linkTextController.clear();
      setState(() {
        loading = false;
      });
      // List<Post> posts = [];

      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("posts").limit(5).get();

      // for (var doc in querySnapshot.docs) {
      //   Post post = Post.fromDocument(doc);

      //   posts.add(post);
      // }

      // DocumentSnapshot doc = await FirebaseFirestore.instance
      //     .collection("posts")
      //     .doc("y273t57232u323u")
      //     .get();

      // Post post = Post.fromDocument(doc);

      // print(post.title);
    } catch (e) {
      print(e.toString());
      showErrorDialog(context, e.toString());
      showCustomToast("An error occured", type: "Error");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    attachFiles = [
      AttachFiles(name: "Images", image: Config.image, onPressed: selectImage),
      AttachFiles(name: "Videos", image: Config.video, onPressed: _pickVideo),
      AttachFiles(name: "PDF", image: Config.pdf, onPressed: selectDocuments),
      AttachFiles(name: "Audio", image: Config.audio, onPressed: _pickAudio)
    ];
    super.initState();
  }

  @override
  void dispose() {
    headingController.dispose();
    bodyController.dispose();
    footerController.dispose();
    linkTextController.dispose();
    linkController.dispose();
    _videoPlayerController?.dispose();
    _positionSubscription?.cancel();
       if (kIsWeb && _videoUrl != null) {
      html.Url.revokeObjectUrl(_videoUrl!); 
    }
       _audioPlayer.dispose();
    if (kIsWeb && _audioUrl != null) {
      html.Url.revokeObjectUrl(_audioUrl!); // Clean up blob URL for web
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isMobile =
            sizingInformation.isMobile || sizingInformation.isTablet;
        return !isMobile
            ? AlertDialog(
                content: SizedBox(
                  width: size.width * 0.5,
                  child: SingleChildScrollView(
                    child: buildPost(isMobile),
                  ),
                ),
              )
            : buildPost(isMobile);
      },
    );
  }

  Widget buildPost(bool isMobile) {
    final size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showLinkFields)
                Column(
                  children: [
                    CustomTextField(
                      controller: headingController,
                      labelText: "Header",
                      hintText: "Header",
                      textInputType: TextInputType.text,
                      border: UnderlineInputBorder(),
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? null : 12,
                      maxLength: 220,
                     
                    ),
                  
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        showHeadingField = !showHeadingField;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset(
                        projectSectors.first.imageUrl,
                        height: 35,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showLinkFields = !showLinkFields;
                      });
                    },
                    child: Image.asset(
                      showLinkFields ? Config.remove : Config.plus,
                      width: 30,
                    ),
                  ),
                ],
              ),
              Text(
                "Create Post ..",
                style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Config.drawerColor,
                    fontSize: isMobile ? 25 : 17,),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(),
              Row(
                children: [
                  ...attachFiles.map((attach) {
                    return InkWell(
                      onTap: attach.onPressed,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              attach.image,
                              width: 25,
                              height: 32,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              attach.name,
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                  Spacer(),
                  CustomButton(
                    title: "  Post  ",
                    loading: loading,
                    borderRadius: 15,
                    onPressed: createPost,
                    isTight: true,
                  ),
                ],
              ),
              // Align(
              //     alignment: Alignment.centerRight,
              //     child: Text(
              //       "1000",
              //       style: context.bodySmall,
              //     )),
              if (pickedImages != null)
                Visibility(
                    visible: pickedImages != null,
                    child: Image.memory(pickedImages!.first.bytes!)),
                  if (_videoPlayerController != null &&
              _videoPlayerController!.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: Stack(children: [VideoPlayer(_videoPlayerController!),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: IconButton(onPressed: (){ setState(() {
                  if (_videoPlayerController!.value.isPlaying) {
                    _videoPlayerController!.pause();
                  } else {
                    _videoPlayerController!.play();
                  }
                });}, icon: _videoPlayerController!.value.isPlaying ? Icon(Icons.play_circle) : Icon(Icons.pause_circle)))]),
            ),
        if (_isAudioSelected)
           Column(
                children: [
                  buildProgressBar(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          _audioPlayer.play();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: () {
                          _audioPlayer.pause();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: () {
                          _audioPlayer.stop();
                        },
                      ),
                    ],
                  ),
                  Text(
                    "${_audioPosition.inMinutes}:${(_audioPosition.inSeconds % 60).toString().padLeft(2, '0')}"
                    " / ${_audioDuration.inMinutes}:${(_audioDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                  ),
                ],
              ),
              CustomTextField(
                controller: bodyController,
                labelText: showLinkFields ? "Footer" : "Acknowledgements etc..",
                hintText: "Acknowledgements etc..",
                textInputType: TextInputType.text,
                maxLines: 2,
                border: UnderlineInputBorder(),
                fontSize: isMobile ? null : 12,
                maxLength: 100,
                
              ),
           
              if (showLinkFields)
                Column(
                  children: [
                    // CustomTextField(
                    //   controller: footerController,
                    //   labelText: "Footer",
                    //   hintText: "Footer",
                    //   textInputType: TextInputType.text,
                    //   border: UnderlineInputBorder(),
                    
                    // ),
                    // Align(
                    //     alignment: Alignment.centerRight,
                    //     child: Text(
                    //       "100",
                    //       style: context.bodySmall,
                    //     )),
                    CustomTextField(
                      controller: linkTextController,
                      labelText: "External Link Text",
                      hintText: "External Link Text",
                      textInputType: TextInputType.text,
                      border: UnderlineInputBorder(),
                      fontSize: isMobile ? null : 12,
                      maxLength: 45,
                    ),
                 
                    CustomTextField(
                      controller: linkController,
                      labelText: "External URL",
                      hintText: "External URL",
                      textInputType: TextInputType.url,
                      border: UnderlineInputBorder(),
                      fontSize: isMobile ? null : 12,
                      maxLength: 500,
                    ),
                  
                    // CustomButton(
                    //     title: "Create Post",
                    //     loading: loading,
                    //     onPressed: createPost)
                  ],
                ),
              if (showHeadingField)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Config.drawerColor.withOpacity(0.1),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Change Post Sector..",
                            style: context.titleLarge?.copyWith(
                                color: Config.drawerColor,
                                ),
                          ),
                          IconButton(
                              onPressed: () {
                                showScectorListings(context);
                              },
                              icon: Image.asset(
                                Config.refresh,
                              )),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  showHeadingField = !showHeadingField;
                                });
                              },
                              icon: Image.asset(
                                Config.x,
                                width: 20,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        height: size.height * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image:
                                    AssetImage(projectSectors.first.imageUrl),
                                fit: BoxFit.cover)),
                      ),
                      CustomHeadingText(text: "${projectSectors.first.title}")
                    ],
                  ),
                )
            ]));
  }
}


//  return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Align(
//               alignment: Alignment.center,
//               child: Text(
//                 "Create Post",
//                 style:
//                     context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//               )),
//           SizedBox(
//             height: 10,
//           ),
//           Align(
//               alignment: Alignment.center,
//               child: Text("Post your thoughts and ideas here")),
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Change Sector",
//                 style: context.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold, color: Config.lightBlueColor),
//               ),
//               Column(
//                 children: [
//                   Text(
//                     "Sector Panel",
//                     style: context.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold, color: Config.drawerColor),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10.0),
//                     child: Image.asset(
//                       projectSectors.first.imageUrl,
//                       height: 50,
//                       width: 100,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//           CustomHeadingText(
//             text: "Post Heading",
//             onTap: () {
//               setState(() {
//                 showHeadingField = !showHeadingField;
//               });
//             },
//           ),
//           if (showHeadingField)
//             CustomTextField(
//                 controller: headingController,
//                 labelText: "Post Heading",
//                 hintText: "Increase engagement with a good heading ...",
//                 textInputType: TextInputType.text),
//           const CustomHeadingText(text: "Post Text"),
//           CustomTextField(
//             controller: bodyController,
//             labelText: "What is your inspiration today?",
//             hintText: "What is your inspiration today?",
//             textInputType: TextInputType.text,
//             maxLines: 4,
//           ),
//           const CustomHeadingText(text: "Add files to your post: "),
//           Row(
//             children: [
//               ...attachFiles.map((attach) {
//                 return InkWell(
//                   onTap: attach.onPressed,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Image.asset(
//                           attach.image,
//                           width: 30,
//                           height: 32,
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         Text(attach.name)
//                       ],
//                     ),
//                   ),
//                 );
//               })
//             ],
//           ),
//           CustomHeadingText(
//             text: "Post Footer",
//             onTap: () {
//               setState(() {
//                 showFooterField = !showFooterField;
//               });
//             },
//           ),
//           if (showFooterField)
//             CustomTextField(
//                 controller: footerController,
//                 labelText: "Footer",
//                 hintText: "Acknowledgements, Disclaimers, etc",
//                 textInputType: TextInputType.text),
//           CustomHeadingText(
//             text: "Post a link to external website here",
//             onTap: () {
//               setState(() {
//                 showLinkFields = !showLinkFields;
//               });
//             },
//           ),
//           if (showLinkFields)
//             Column(
//               children: [
//                 CustomTextField(
//                     controller: linkTextController,
//                     labelText: "",
//                     hintText: "Link text description",
//                     textInputType: TextInputType.text),
//                 CustomTextField(
//                     controller: linkController,
//                     labelText: "Link",
//                     hintText: "Link to website",
//                     textInputType: TextInputType.url),
//               ],
//             ),
//           CustomButton(
//             title: "POST",
//             loading: false,
//             onPressed: () {},
//             isTight: true,
//           ),
//           CheckboxListTile(
//               value: unPublish,
//               controlAffinity: ListTileControlAffinity.leading,
//               title: Text(
//                 "Un-Publish Post (Check and Click Save Post)",
//                 style: context.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold, color: Config.lightBlueColor),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   unPublish = !unPublish;
//                 });
//               }),
//           CheckboxListTile(
//               value: reply,
//               controlAffinity: ListTileControlAffinity.leading,
//               title: Text(
//                 "Disable Replying",
//                 style: context.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold, color: Config.lightBlueColor),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   reply = !reply;
//                 });
//               }),
//           CheckboxListTile(
//               value: badge,
//               controlAffinity: ListTileControlAffinity.leading,
//               title: Text(
//                 "Disable Badgeless Replies",
//                 style: context.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold, color: Config.lightBlueColor),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   badge = !badge;
//                 });
//               }),
//           TextButton(
//               onPressed: () {
//                 showToolDialog(
//                     context,
//                     "1AMov Post to Product",
//                     "Convert your post to a\nproduct and start selling\ndirectly on 1AMov.",
//                     "Add ‘Pay to Read’ text to your articles, make your videos ‘Pay to Watch’ and your PDF publications ‘Pay to Download.’ Start selling right now.",
//                     "Set price, shipping cost, delivery options, etc for your physical products and you are in business.",
//                     "(Increase Trust in your Buyers with a ‘Profile Badge’)",
//                     "Post to Product",
//                     true,
//                     () {});
//               },
//               child: Text(
//                 "Post to Product Tools",
//                 style: context.titleText,
//               )),
//           TextButton(
//               onPressed: () {
//                 showToolDialog(
//                     context,
//                     "Advertising Tools",
//                     "Convert your post to an Advert.",
//                     "Get metrics on advert reach, set prefered audience, duration of advert and bid options.",
//                     "No special expertise required. Simple, direct & effective.",
//                     "(Available to Verified Accounts)",
//                     "Advertising Tools",
//                     false,
//                     () {});
//               },
//               child: Text(
//                 "Advertising Tools",
//                 style: context.titleText,
//               )),
//           TextButton(
//               onPressed: () {
//                 showToolDialog(
//                     context,
//                     "1AMov Venture Tools",
//                     "",
//                     "Create a Venture Post with Images, Video, PDF pitch decks or Business plans. Raise capital and attract investors for your existing business or idea.",
//                     "",
//                     "(Available for Verified Accounts)",
//                     "Venture Tools",
//                     false,
//                     () {});
//               },
//               child: Text(
//                 "Business/Venture Tools",
//                 style: context.titleText,
//               ))
//         ],
//       ),
//     );