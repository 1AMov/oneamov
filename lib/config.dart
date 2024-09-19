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
  static const String devID = "1725197381572";

  static const String dateFormat = 'dd-MMM-yyyy';

  // COLORS
  static const Color themeColor = Colors.red;
  static const Color drawerColor = Colors.grey;
  static const Color scaffoldBackgroundColor = Colors.white;

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
