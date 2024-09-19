import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oneamov/providers/base_ui_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../common_functions/software_version.dart';
import '../config.dart';
import '../widgets/progress_widget.dart';
import 'email_verification_page.dart';

class HomePage extends StatefulWidget {
  final String userID;
  final String currentPage;
  final String secondID;
  final String thirdPage;
  const HomePage(
      {super.key,
      required this.userID,
      required this.currentPage,
      required this.secondID,
      required this.thirdPage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    getVersion(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildBody(Size size) {
    switch (widget.currentPage) {
      default:
        return Text("Error: Can't find page '${widget.currentPage}'");
    }
  }

  Widget desktopLayout(Size size, double firstSectionMaxWidth) {
    return Scaffold(
      body: Center(
        child: Text("This is the HOME PAGE (DESKTOP UI)"),
      ),
    );
  }

  Widget mobileLayout(Size size) {
    return Scaffold(
      body: Center(
        child: Text("This is the HOME PAGE (MOBILE UI)"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double firstSectionMaxWidth =
        context.watch<BaseUIProvider>().firstSectionMaxWidth;

    if (Config.isDebugMode) {
      return loading
          ? circularProgress()
          : ScreenTypeLayout.builder(
              desktop: (context) => desktopLayout(size, firstSectionMaxWidth),
              tablet: (context) => mobileLayout(size),
              mobile: (context) => mobileLayout(size),
              watch: (context) => Container(),
            );
    } else {
      return loading
          ? circularProgress()
          : StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return linearProgress();
                } else {
                  if (snapshot.data!.emailVerified) {
                    return ScreenTypeLayout.builder(
                      desktop: (context) =>
                          desktopLayout(size, firstSectionMaxWidth),
                      tablet: (context) => mobileLayout(size),
                      mobile: (context) => mobileLayout(size),
                      watch: (context) => Container(),
                    );
                  } else {
                    return EmailVerificationPage(
                      onVerified: () => setState(() {}),
                    );
                  }
                }
              });
    }
  }
}
