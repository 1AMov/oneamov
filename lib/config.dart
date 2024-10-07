import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
//
// EMAIL: oneamov@gmail.com
// PASSWORD: @1AMovApp

class Config {
  static const String appName = "1AMov";
  static const String tagLine = "Let's Get Organized";
  static const String version = "1.0.0";

  static bool isDebugMode = false;
  static const String devID = "xyjArjf2g8aezP1IkWPNz4DCxq72";

  static const String dateFormat = 'dd-MMM-yyyy';

  // COLORS
  static const Color themeColor = Colors.red;
  static const Color primaryColor = Color(0xFFfe3300);
  static const Color drawerColor = Colors.grey;
  static const Color scaffoldBackgroundColor = Colors.white;
  static const Color splashBackgroundColor = Colors.black;
  static const Color lightBlueColor = Color(0xFF6492be);
  static const Color greenColor = Color(0xFF5d9855);

  // SCROLLBAR
  static const double scrollbarWidth = 12.0;
  static const double scrollbarWidthMobile = 3.0;

  // SHADOWS
  static BoxShadow boxShadow = BoxShadow(
      color: Colors.black.withOpacity(0.05),
      offset: const Offset(0, 4.0),
      spreadRadius: 0.0,
      blurRadius: 16.0);

  // IMAGES
  static const String logo = "assets/logo/OneAMovlogo2.png";
  static const String logoWhite = "assets/logo/OneAMovlogo2_white.png";
  static const String loginImage = logo;
  static const String mailSentImage = "assets/images/mail_sent.png";
  static const String profileImage = "assets/images/profile.png";
  static const String audio = "assets/images/postaudio.png";
  static const String image = "assets/images/postimage.png";
  static const String pdf = "assets/images/postpdf.png";
  static const String video = "assets/images/postvideo.png";
  static const String x = "assets/images/458595.png";
  static const String plus = "assets/images/plus-152614_1280.png";
  static const String country = "assets/images/country.png";
  static const String loveBlack = "assets/images/love.png";
  static const String loveWhite = "assets/images/love1.png";
  static const String thumbgrey = "assets/images/441-441888.png";
  static const String thumbWhite = "assets/images/441-441888a.png";
  static const String eyeGrey = "assets/images/201934-200.png";
  static const String addPhoto = "assets/images/add-po19-2569.png";
  static const String buttonArrow = "assets/images/button-arrow-expand-1.png";
  static const String commentBlack = "assets/images/comment.png";
  static const String refresh = "assets/images/refresh.png";
  static const String commentGrey = "assets/images/reps.png";
  static const String shareGrey = "assets/images/share.png";
  static const String userPlaceholder =
      "assets/images/userimageplaceholder.png";
  static const String setting = "assets/images/setting.png";
  static const String remove = "assets/images/remove.png";

  // COLLECTION NAMES
  static const String users = "users";
  static const String posts = "posts";
  static const String transactions = "transactions";
  static const String notifications = "notifications";
  static const String maintenance = "maintenance";

  // COLLECTIONS
  static CollectionReference get usersCollection =>
      FirebaseFirestore.instance.collection(users);
  static CollectionReference get postsCollection =>
      FirebaseFirestore.instance.collection(posts);
  static CollectionReference get transactionsCollection =>
      FirebaseFirestore.instance.collection(transactions);
  static CollectionReference get notificationsCollection =>
      FirebaseFirestore.instance.collection(notifications);
  static CollectionReference get maintenanceCollection =>
      FirebaseFirestore.instance.collection(maintenance);

  // JSON FILES
  static const String countriesAndCitiesJson =
      "assets/json/countries_and_cities.json";
  static const String currenciesJson = "assets/json/currencies.json";
}
