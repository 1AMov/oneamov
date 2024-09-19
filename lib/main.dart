import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'config.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/base_ui_provider.dart';
import 'providers/navigation_provider.dart';
import 'routes.dart';

// Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
// gsutil cors set cors.json gs://<appID>.appspot.com

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // turn off the # in the URLs on the web
  setPathUrlStrategy();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider()),
      ChangeNotifierProvider<AuthStateProvider>(
          create: (_) => AuthStateProvider()),
      ChangeNotifierProvider<BaseUIProvider>(create: (_) => BaseUIProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Config.appName,
      debugShowCheckedModeBanner: Config.isDebugMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Config.themeColor),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
      ),
      routerConfig: CustomRoutes.router,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  void displaySplash() async {
    Timer(const Duration(seconds: 3), () async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!Config.isDebugMode) {
          // Proceed to LOGIN

          GoRouter.of(context).go("/auth/login");
        } else {
          // Bypass login in dev mode
          GoRouter.of(context).go("/${Config.devID}/home");
        }
      } else {
        // Do NOT display userID
        // Instead show user timestamp for security

        QuerySnapshot querySnapshot = await Config.usersCollection
            .where("userID", isEqualTo: user.uid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          if (querySnapshot.docs.first["rememberMe"]) {
            String userID = querySnapshot.docs.first.id;

            Timer(const Duration(seconds: 1), () {
              Provider.of<NavigationProvider>(context, listen: false)
                  .setCurrentPage("home");

              GoRouter.of(context).go("/$userID/home");
            });
          } else {
            if (!Config.isDebugMode) {
              // Proceed to LOGIN

              GoRouter.of(context).go("/auth/login");
            } else {
              // Bypass login in dev mode
              GoRouter.of(context).go("/${Config.devID}/home");
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: Config.logo,
              child: Image.asset(
                Config.logo,
                width: 200.0,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(Config.tagLine, style: Theme.of(context).textTheme.titleSmall!
                // .copyWith(fontSize: 20.0),
                )
          ],
        ),
      ),
    );
  }
}
