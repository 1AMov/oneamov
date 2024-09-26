import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../common_functions/custom_toast.dart';
import '../config.dart';
import '../dialog/error_dialog.dart';
import '../models/account.dart';
import '../providers/auth_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_wrapper.dart';
import '../widgets/option_widget.dart';
import '../widgets/password_strength_checker.dart';
import 'auth_footer.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    super.key,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController fullNamesCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController cPasswordCtrl = TextEditingController();
  bool showPassword = false;
  bool showCPassword = false;
  bool agreeToTerms = false;

  String city = "";
  String countryOfOrigin = "";
  String countryOfResidence = "";

  Future<void> createUser(String phone) async {
    setState(() {
      loading = true;
    });

    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
      );

      Account account = Account(
          userID: credential.user!.uid,
          userName: userNameCtrl.text.trim(),
          fullNames: fullNamesCtrl.text.trim(),
          email: emailCtrl.text.trim(),
          phone: phone,
          photoUrl: "",
          dateOfBirth: 0,
          gender: "",
          slogan: "",
          about: "",
          website: "",
          uniqueViews: 0,
          totalViews: 0,
          accountStatusID: "",
          isLegacyVerified: false,
          isPioneer: false,
          memberBadgeID: "",
          supporterBadgeID: "",
          address: "",
          city: city,
          countryOfOrigin: countryOfOrigin,
          countryOfResidence: countryOfResidence,
          role: "user",
          timestamp: timestamp,
          lastLogin: timestamp,
          isOnline: true,
          deviceTokens: [],
          devices: [],
          metadata: {});

      await Config.usersCollection.doc(account.userID).set(account.toMap());

      showCustomToast("Your account has been created", type: "");

      setState(() {
        loading = false;
        userNameCtrl.clear();
        emailCtrl.clear();
        passwordCtrl.clear();
        cPasswordCtrl.clear();
        Provider.of<AuthStateProvider>(context, listen: false).resetTexts();
      });

      Timer(const Duration(seconds: 1), () {
        // GoRouter.of(context)
        //     .go("/subscribe/${widget.userRole}/${account.timestamp}");
        Provider.of<NavigationProvider>(context, listen: false)
            .setCurrentPage("home");

        GoRouter.of(context).go("/${account.userID}/home?layout=flow");
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');

        showErrorDialog(context, 'The password provided is too weak.');

        showCustomToast("The password provided is too weak.", type: "error");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');

        showErrorDialog(context, 'The account already exists for that email.');

        showCustomToast("The account already exists for that email.",
            type: "error");
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.toString());

      showErrorDialog(context, e.toString());

      showCustomToast("An Error occurred :(", type: "error");

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    userNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    cPasswordCtrl.dispose();
    // Provider.of<AuthStateProvider>(context, listen: false).resetTexts();
    super.dispose();
  }

  List<Widget> passwordOptionsAndButton(String phone) {
    return [
      CustomTextField(
        controller: passwordCtrl,
        enabled: !loading,
        obscureText: !showPassword,
        labelText: "Password",
        hintText: "password",
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
          child: Icon(showPassword
              ? Icons.visibility_rounded
              : Icons.visibility_off_rounded),
        ),
        textInputType: TextInputType.visiblePassword,
        onChanged: (v) {
          context.read<AuthStateProvider>().onPasswordChanged(v);
        },
        validator: (value) => PasswordStrengthChecker(
                  password: value!,
                ).calculatePasswordStrength() !=
                100
            ? 'Please fill this field.'
            : null,
      ),
      CustomTextField(
        controller: cPasswordCtrl,
        enabled: !loading,
        obscureText: !showCPassword,
        labelText: "Confirm Password",
        hintText: "password",
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              showCPassword = !showCPassword;
            });
          },
          child: Icon(showCPassword
              ? Icons.visibility_rounded
              : Icons.visibility_off_rounded),
        ),
        textInputType: TextInputType.visiblePassword,
        validator: (value) =>
            value! != passwordCtrl.text ? 'Passwords do not match.' : null,
      ),
      const SizedBox(height: 10.0),
      PasswordStrengthChecker(
          password: context.watch<AuthStateProvider>().password),
      const SizedBox(height: 10.0),

      OptionWidget(
          contents: [
            RichText(
              text: TextSpan(
                // style: Theme.of(context).textTheme.bodySmall,
                children: <TextSpan>[
                  const TextSpan(text: "I agree to all the "),
                  TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = () {},
                      text: "Terms",
                      style: const TextStyle(
                          color: Config.themeColor,
                          fontWeight: FontWeight.w700)),
                  const TextSpan(text: " and "),
                  TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = () {},
                      text: "Privacy Policy",
                      style: const TextStyle(
                          color: Config.themeColor,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
          value: agreeToTerms,
          onChanged: (v) {
            setState(() {
              agreeToTerms = v!;
            });
          }),
      // const SizedBox(height: 10.0),
      // BUTTON
      CustomWrapper(
        maxWidth: 300.0,
        child: BorderButton(
            title: "Sign Up",
            isActive: true,
            color: Colors.grey,
            insidePadding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            onPressed: () {
              if (_formKey.currentState!.validate() && agreeToTerms) {
                createUser(phone);
              } else {
                if (!agreeToTerms) {
                  showCustomToast("Please agree to Terms and Privacy Policy",
                      type: "error");
                } else {
                  showCustomToast("Fill the required fields", type: "error");
                }
              }
            }),
      ),

      const SizedBox(height: 5.0),
    ];
  }

  Widget emailField(String title) {
    return CustomTextField(
      controller: emailCtrl,
      enabled: !loading,
      labelText: title,
      hintText: "example@domain.com",
      textInputType: TextInputType.emailAddress,
      onChanged: (v) => context.read<AuthStateProvider>().validateEmail(v),
      validator: (value) => value!.isEmpty ? 'Please enter an Email' : null,
      // context.watch<AuthStateProvider>().emailErrorText,
    );
  }

  Widget phoneField() {
    return CustomPhoneField(
      controller: phoneCtrl,
      enabled: !loading,
      onChanged: (p) =>
          context.read<AuthStateProvider>().onPhoneChanged(p.completeNumber),
      validator: (p) => p!.number.isEmpty ? "Please fill this field." : null,
    );
  }

  Widget cityField() {
    return CityPicker(
      selectedCity: city,
      onChanged: (v) {
        setState(() {
          city = v!;
        });
      },
      validator: (value) => value!.isEmpty ? 'Please fill this field.' : null,
    );
  }

  Widget countryField(String title, String variable) {
    return CountryPicker(
      title: title,
      selectedCountry: variable,
      onChanged: (v) {
        setState(() {
          variable = v!;
        });
      },
      validator: (value) => value!.isEmpty ? 'Please fill this field.' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    String phone = context.watch<AuthStateProvider>().completePhoneNumber;

    return ResponsiveBuilder(builder: (context, sizingInfo) {
      bool isDesktop = sizingInfo.isDesktop;

      return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sign Up",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Config.themeColor),
            ),
            const SizedBox(height: 10.0),
            CustomTextField(
              controller: userNameCtrl,
              labelText: "Username",
              hintText: "Username",
              enabled: !loading,
              textInputType: TextInputType.name,
              validator: (value) =>
                  value!.isEmpty ? 'Please fill this field.' : null,
            ),
            CustomTextField(
              controller: fullNamesCtrl,
              labelText: "Full Name",
              hintText: "John Doe",
              enabled: !loading,
              textInputType: TextInputType.name,
              validator: (value) =>
                  value!.isEmpty ? 'Please fill this field.' : null,
            ),
            emailField("Email Address"),
            phoneField(),
            cityField(),
            const SizedBox(height: 10.0),
            countryField("Country of Origin", countryOfOrigin),
            const SizedBox(height: 10.0),
            countryField("Country of Residence", countryOfResidence),
            const SizedBox(height: 10.0),
            ...passwordOptionsAndButton(phone),
            const SizedBox(height: 20.0),
            const Text(
              "OR",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20.0),
            CustomWrapper(
              maxWidth: 300.0,
              child: BorderButton(
                  title: "Sign In",
                  isActive: true,
                  color: Colors.grey,
                  insidePadding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  onPressed: () {
                    context.go("/auth/login");
                  }),
            ),
            const SizedBox(height: 40.0),
            const AuthFooter()
          ],
        ),
      );
    });
  }
}
