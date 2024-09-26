import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oneamov/pages/feed_page.dart';
import 'package:oneamov/pages/new_post.dart';
import 'package:oneamov/pages/sectors_listing.dart';
import 'package:oneamov/providers/base_ui_provider.dart';
import 'package:oneamov/widgets/custom_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../common_functions/software_version.dart';
import '../config.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_scrollbar.dart';
import '../widgets/progress_widget.dart';
import 'email_verification_page.dart';

class HomePage extends StatefulWidget {
  final String userID;
  final String currentPage;
  final String secondID;
  final String thirdPage;
  final Map<String, dynamic> query;
  const HomePage(
      {super.key,
      required this.userID,
      required this.currentPage,
      required this.secondID,
      required this.thirdPage,
      required this.query});

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
      case 'home':
        return FeedPage(userID: widget.userID);
      case "new_post":
        return NewPost();
      default:
        return Text("Error: Can't find page '${widget.currentPage}'");
    }
  }

  Widget desktopLayout(Size size, double firstSectionMaxWidth) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Config.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
          ),
          Positioned.fill(
              child: CustomScrollBar(
            controller: _controller,
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomWrapper(
                    maxWidth: 1000.00,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                            width: firstSectionMaxWidth,
                            child: CustomDrawer(
                              userID: widget.userID,
                              isMobile: false,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              CustomAppbar(
                                  userID: widget.userID,
                                  scaffoldKey: scaffoldKey),
                              buildBody(size),
                            ],
                          ),
                        ),
                        const Expanded(flex: 1, child: SectorsListing())
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget mobileLayout(Size size) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Config.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size(size.width, kTextTabBarHeight + 5),
        child: CustomAppbar(userID: widget.userID, scaffoldKey: scaffoldKey),
      ),
      drawer: CustomDrawer(
        userID: widget.userID,
        isMobile: true,
      ),
      body: CustomScrollBar(
        controller: _controller,
        child: SingleChildScrollView(
          controller: _controller,
          child: buildBody(size),
        ),
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
