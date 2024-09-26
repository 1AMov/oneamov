import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String userID; // THIS IS THE DOCUMENT ID
  String userName;
  String fullNames;
  String email;
  String phone;
  String photoUrl;
  int dateOfBirth;
  String gender;
  String slogan;
  String about;
  String website;
  int uniqueViews;
  int totalViews;
  String accountStatusID;
  bool isLegacyVerified;
  bool isPioneer;
  String memberBadgeID;
  String supporterBadgeID;
  String address;
  String city;
  String countryOfOrigin;
  String countryOfResidence;
  String role; // "admin" or "user"
  int timestamp;
  int lastLogin;
  bool isOnline;
  List<dynamic> deviceTokens; // For Push Notifications
  List<dynamic> devices; // For security incase user logs in a new device
  Map<String, dynamic> metadata;

  Account(
      {required this.userID,
      required this.userName,
      required this.fullNames,
      required this.email,
      required this.phone,
      required this.photoUrl,
      required this.dateOfBirth,
      required this.gender,
      required this.slogan,
      required this.about,
      required this.website,
      required this.uniqueViews,
      required this.totalViews,
      required this.accountStatusID,
      required this.isLegacyVerified,
      required this.isPioneer,
      required this.memberBadgeID,
      required this.supporterBadgeID,
      required this.address,
      required this.city,
      required this.countryOfOrigin,
      required this.countryOfResidence,
      required this.role,
      required this.timestamp,
      required this.lastLogin,
      required this.isOnline,
      required this.deviceTokens,
      required this.devices,
      required this.metadata});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      'fullNames': fullNames,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'slogan': slogan,
      'about': about,
      'website': website,
      'uniqueViews': uniqueViews,
      'totalViews': totalViews,
      'accountStatusID': accountStatusID,
      'isLegacyVerified': isLegacyVerified,
      'isPioneer': isPioneer,
      'memberBadgeID': memberBadgeID,
      'supporterBadgeID': supporterBadgeID,
      'address': address,
      'city': city,
      'countryOfOrigin': countryOfOrigin,
      'countryOfResidence': countryOfResidence,
      'role': role,
      'timestamp': timestamp,
      'lastLogin': lastLogin,
      'isOnline': isOnline,
      'deviceTokens': deviceTokens,
      'devices': devices,
      'metadata': metadata
    };
  }

  factory Account.fromDocument(DocumentSnapshot doc) {
    return Account(
        userID: doc['userID'],
        userName: doc['userName'],
        fullNames: doc['fullNames'],
        email: doc['email'],
        phone: doc['phone'],
        photoUrl: doc['photoUrl'],
        dateOfBirth: doc['dateOfBirth'],
        gender: doc['gender'],
        slogan: doc['slogan'],
        about: doc['about'],
        website: doc['website'],
        uniqueViews: doc['uniqueViews'],
        totalViews: doc['totalViews'],
        accountStatusID: doc['accountStatusID'],
        isLegacyVerified: doc['isLegacyVerified'],
        isPioneer: doc['isPioneer'],
        memberBadgeID: doc['memberBadgeID'],
        supporterBadgeID: doc['supporterBadgeID'],
        address: doc['address'],
        city: doc['city'],
        countryOfOrigin: doc['countryOfOrigin'],
        countryOfResidence: doc['countryOfResidence'],
        role: doc['role'],
        timestamp: doc['timestamp'],
        lastLogin: doc['lastLogin'],
        isOnline: doc['isOnline'],
        deviceTokens: doc['deviceTokens'],
        devices: doc['devices'],
        metadata: doc['metadata']);
  }

  factory Account.fromJson(Map<String, dynamic> doc) {
    return Account(
        userID: doc['userID'],
        userName: doc['userName'],
        fullNames: doc['fullNames'],
        email: doc['email'],
        phone: doc['phone'],
        photoUrl: doc['photoUrl'],
        dateOfBirth: doc['dateOfBirth'],
        gender: doc['gender'],
        slogan: doc['slogan'],
        about: doc['about'],
        website: doc['website'],
        uniqueViews: doc['uniqueViews'],
        totalViews: doc['totalViews'],
        accountStatusID: doc['accountStatusID'],
        isLegacyVerified: doc['isLegacyVerified'],
        isPioneer: doc['isPioneer'],
        memberBadgeID: doc['memberBadgeID'],
        supporterBadgeID: doc['supporterBadgeID'],
        address: doc['address'],
        city: doc['city'],
        countryOfOrigin: doc['countryOfOrigin'],
        countryOfResidence: doc['countryOfResidence'],
        role: doc['role'],
        timestamp: doc['timestamp'],
        lastLogin: doc['lastLogin'],
        isOnline: doc['isOnline'],
        deviceTokens: doc['deviceTokens'],
        devices: doc['devices'],
        metadata: doc['metadata']);
  }
}
