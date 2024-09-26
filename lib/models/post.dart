import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String postID;
  String title;

  Post({
    required this.postID,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {"postID": postID, "title": title};
  }

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(postID: doc["postID"], title: doc["title"]);
  }
}
