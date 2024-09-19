import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String userID; // THIS IS THE DOCUMENT ID
  String userName;
  String email;
  String phone;
  String photoUrl;
  String address;
  String city;
  String country;
  bool isApproved;
  String password;
  bool rememberMe;
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
      required this.email,
      required this.phone,
      required this.photoUrl,
      required this.address,
      required this.city,
      required this.country,
      required this.isApproved,
      required this.password,
      required this.rememberMe,
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
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'address': address,
      'city': city,
      'country': country,
      'isApproved': isApproved,
      'password': password,
      'rememberMe': rememberMe,
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
        email: doc['email'],
        phone: doc['phone'],
        photoUrl: doc['photoUrl'],
        address: doc['address'],
        city: doc['city'],
        country: doc['country'],
        isApproved: doc['isApproved'],
        password: doc['password'],
        rememberMe: doc['rememberMe'],
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
        email: doc['email'],
        phone: doc['phone'],
        photoUrl: doc['photoUrl'],
        address: doc['address'],
        city: doc['city'],
        country: doc['country'],
        isApproved: doc['isApproved'],
        password: doc['password'],
        rememberMe: doc['rememberMe'],
        role: doc['role'],
        timestamp: doc['timestamp'],
        lastLogin: doc['lastLogin'],
        isOnline: doc['isOnline'],
        deviceTokens: doc['deviceTokens'],
        devices: doc['devices'],
        metadata: doc['metadata']);
  }
}
