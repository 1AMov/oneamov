import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:oneamov/models/project_sector.dart';

class Post {
  String postID;
  String title;
  String description;
  String footer;
  List<dynamic> tags;
  List<dynamic> hashTags;
  String postType;
  int price;
  String currency;
  Map<String, dynamic> sector;
  String publisherId;
  String link;
  String linkText;
  List<String> imageUrls;
  List<dynamic> videoUrls;
  Documents documents;
  bool fundraise;
  Fundraiser fundraiseData;
  Interactions interactions;
  int timeStamp;

  Post({
    required this.postID,
    required this.title,
    required this.description,
    required this.footer,
    required this.tags,
    required this.hashTags,
    required this.postType,
    required this.price,
    required this.currency,
    required this.sector,
    required this.publisherId,
    required this.link,
    required this.linkText,
    required this.imageUrls,
    required this.videoUrls,
    required this.documents,
    required this.fundraise,
    required this.fundraiseData,
    required this.interactions,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "postID": postID,
      "title": title,
      "description": description,
      "footer": footer,
      "tags": tags,
      "hashTags": hashTags,
      "postType": postType,
      "price": price,
      "currency": currency,
      "sector": sector,
      "publisherId": publisherId,
      "link": link,
      "linkText": linkText,
      "imageUrls": imageUrls,
      "videoUrls": videoUrls,
      "documents": documents.toMap(),
      "fundraise": fundraise,
      "fundraiseData": fundraiseData.toMap(),
      "interactions": interactions.toMap(),
      "timeStamp": timeStamp,
    };
  }

factory Post.fromDocument(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Ensure it's a map

  return Post(
    postID: data["postID"],
    title: data["title"],
    description: data["description"],
    footer: data["footer"],
    tags: List<dynamic>.from(data["tags"]),
    hashTags: List<dynamic>.from(data["hashTags"]),
    postType: data["postType"],
    price: data["price"],
    currency: data["currency"],
    sector: Map<String, dynamic>.from(data["sector"]),
    publisherId: data["publisherId"],
    link: data["link"],
    linkText: data["linkText"],
    imageUrls: List<String>.from(data["imageUrls"]),
    videoUrls: List<dynamic>.from(data["videoUrls"]),
    documents: data["documents"] != null
        ? Documents.fromMap(data["documents"] as Map<String, dynamic>)
        : Documents(name: [], pages: [], size: []), // Default empty object if null
    fundraise: data["fundraise"],
    fundraiseData: data["fundraiseData"] != null
        ? Fundraiser.fromMap(data["fundraiseData"] as Map<String, dynamic>)
        : Fundraiser(target: '', fundraiserId: '', userId: '', amount: 0, currency: '', timestamp: 0),
    interactions: data["interactions"] != null
        ? Interactions.fromMap(data["interactions"] as Map<String, dynamic>)
        : Interactions(likes: 0, loves: 0, shares: 0, comments: 0),
    timeStamp: data["timeStamp"],
  );
}

}

class Fundraiser {
  String target;
  String fundraiserId;
  String userId;
  double amount;
  String currency;
  int timestamp;

  Fundraiser({
    required this.target,
    required this.fundraiserId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "target": target,
      "fundraiserId": fundraiserId,
      "userId": userId,
      "amount": amount,
      "currency": currency,
      "timestamp": timestamp,
    };
  }

factory Fundraiser.fromMap(Map<String, dynamic> map) {
  return Fundraiser(
    target: map["target"],
    fundraiserId: map["fundraiserId"],
    userId: map["userId"],
    amount: (map["amount"] as num).toDouble(), // Ensure it's a double
    currency: map["currency"],
    timestamp: map["timestamp"],
  );
}

}

class Like {
  final String likeId;
  final String userId;
  final int timestamp;

  Like({
    required this.likeId,
    required this.userId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "likeId": likeId,
      "userId": userId,
      "timestamp": timestamp,
    };
  }

  factory Like.fromDocument(DocumentSnapshot doc) {
    return Like(
      likeId: doc["likeId"],
      userId: doc["userId"],
      timestamp: doc["timestamp"],
    );
  }
}

class Love {
  final String loveId;
  final String userId;
  final int timestamp;

  Love({
    required this.loveId,
    required this.userId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "loveId": loveId,
      "userId": userId,
      "timestamp": timestamp,
    };
  }

  factory Love.fromDocument(DocumentSnapshot doc) {
    return Love(
      loveId: doc["loveId"],
      userId: doc["userId"],
      timestamp: doc["timestamp"],
    );
  }
}

class Share {
  final String shareId;
  final String userId;
  final int timestamp;

  Share({
    required this.shareId,
    required this.userId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "shareId": shareId,
      "userId": userId,
      "timestamp": timestamp,
    };
  }

  factory Share.fromDocument(DocumentSnapshot doc) {
    return Share(
      shareId: doc["shareId"],
      userId: doc["userId"],
      timestamp: doc["timestamp"],
    );
  }
}

class Comment {
  final String commentId;
  final String userId;
  final String content;
  final int timestamp;

  Comment({
    required this.commentId,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "commentId": commentId,
      "userId": userId,
      "content": content,
      "timestamp": timestamp,
    };
  }

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      commentId: doc["commentId"],
      userId: doc["userId"],
      content: doc["content"],
      timestamp: doc["timestamp"],
    );
  }
}

class Documents {
  List<String> name;
  List<int> pages;
  List<int> size;

  Documents({required this.name, required this.pages, required this.size});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "pages": pages,
      "size": size,
    };
  }

factory Documents.fromMap(Map<String, dynamic> map) {
  return Documents(
    name: map["name"] is String 
        ? [map["name"]] 
        : List<String>.from(map["name"]), // Handle both String and List<String>
    pages: map["pages"] is int
        ? [map["pages"]]
        : List<int>.from(map["pages"]),  // Handle both int and List<int>
    size: map["size"] is int
        ? [map["size"]]
        : List<int>.from(map["size"]),   // Handle both int and List<int>
  );
}


}

class Interactions {
  int likes;
  int shares;
  int loves;
  int comments;

  Interactions({
    required this.likes,
    required this.loves,
    required this.shares,
    required this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      "likes": likes,
      "loves": loves,
      "shares": shares,
      "comments": comments,
    };
  }

factory Interactions.fromMap(Map<String, dynamic> map) {
  return Interactions(
    likes: map["likes"],
    loves: map["loves"],
    shares: map["shares"],
    comments: map["comments"],
  );
}

}
