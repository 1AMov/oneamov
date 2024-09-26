import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../config.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_scrollbar.dart';
import '../widgets/custom_wrapper.dart';
import 'forgot_password.dart';
import 'login.dart';
import 'signup.dart';

class AuthPage extends StatefulWidget {
  final String page;
  const AuthPage({
    super.key,
    required this.page,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final ScrollController _scrollController = ScrollController();

  Widget buildForm() {
    switch (widget.page) {
      case "login":
        return const Login();
      case "signup":
        return const SignUp();
      case "forgot_password":
        return const ForgotPassword();
      default:
        return const Login();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget authImage(Size size) {
    return Image.asset(
      Config.loginImage,
      // height: 200.0,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(builder: (context, sizingInfo) {
      bool isDesktop = sizingInfo.isDesktop;

      return SafeArea(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
              ),
              // Opacity(
              //   opacity: 0.5,
              //   child: Image.asset(
              //     Config.rentImage,
              //     height: size.height,
              //     width: size.width,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Positioned.fill(
                child: CustomScrollBar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50.0),
                        // if (isDesktop && widget.page != "signup") ...[
                        //   CustomWrapper(
                        //     maxWidth: 800.0,
                        //     child: CustomContainer(
                        //       containerInsidePadding: EdgeInsets.zero,
                        //       color: const Color.fromRGBO(245, 245, 245, 1.0),
                        //       child: Row(
                        //         children: [
                        //           Expanded(
                        //             flex: 1,
                        //             child: Container(
                        //               constraints: const BoxConstraints(
                        //                   minHeight: 480.0),
                        //               padding: const EdgeInsets.symmetric(
                        //                   vertical: 10.0, horizontal: 15.0),
                        //               decoration: const BoxDecoration(
                        //                   color: Colors.white,
                        //                   borderRadius: BorderRadius.horizontal(
                        //                       left: Radius.circular(10.0))),
                        //               child: Center(child: buildForm()),
                        //             ),
                        //           ),
                        //           Expanded(
                        //             flex: 1,
                        //             child: authImage(size),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   )
                        // ] else ...[
                        CustomWrapper(
                          maxWidth: 800.0,
                          child: CustomContainer(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 100.0, child: authImage(size)),
                                const SizedBox(height: 10.0),
                                CustomWrapper(
                                  maxWidth: 400.0,
                                  child: buildForm(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ]
                        const SizedBox(height: 50.0),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
