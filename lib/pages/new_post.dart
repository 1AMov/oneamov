import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:oneamov/config.dart';
import 'package:oneamov/models/account.dart';
import 'package:oneamov/models/post.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  Future<void> muFunction(String parameterA) async {
    // int timestamp = DateTime.now().millisecondsSinceEpoch;

    // Post post = Post(postID: timestamp.toString(), title: "A nice title");

    // await FirebaseFirestore.instance.collection("posts").doc(post.postID).set(post.toMap());

    // List<Post> posts = [];

    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("posts").limit(5).get();

    // for (var doc in querySnapshot.docs) {
    //   Post post = Post.fromDocument(doc);

    //   posts.add(post);
    // }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("posts")
        .doc("y273t57232u323u")
        .get();

    Post post = Post.fromDocument(doc);

    print(post.title);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [Text("New Post UI here"), Text("Input fields come here")],
    );
  }
}
