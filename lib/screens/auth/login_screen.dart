import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app_router.dart';
import '/components/widgets/ink_well_custom.dart';
import '/components/widgets/toned_btn.dart';
import '/components/widgets/toned_text_field.dart';
import '/providers/auth_service.dart';
import '/style/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late FocusNode _emailNode, _passNode;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    _emailNode = FocusNode();
    _passNode = FocusNode();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, provider, wid) {
      return InkWellCustom(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 28),
                    child: Text(
                      'Login',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        seTextField(
                          title: 'Email',
                          controller: _email,
                          textInputType: TextInputType.emailAddress,
                          isForm: true,
                          validator: 1,
                          autoFocus: true,
                          hintText: 'abc@xyz.com',
                          focusNode: _emailNode,
                          onFieldSubmitted: (val) {
                            _passNode.requestFocus();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        seTextField(
                          title: 'Password',
                          controller: _password,
                          bottomPadding: 18,
                          obscure: true,
                          validator: 0,
                          isForm: true,
                          hintText: '6HNx^44k1',
                          autoFocus: true,
                          focusNode: _passNode,
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (val) async {
                            if (_formKey.currentState!.validate()) {
                              await provider.signInUserWithEmail(_email.text, _password.text, context);

                              // stripePayments.attachPaymentMethod(paymentIntentId, customerID);
                            }
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, AppRoute.forgotScreen),
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextBtn(
                    width: 200,
                    color: primaryColor,
                    title: "Login",
                    onTap: () async {
                      //  getToken("ad");

                      if (_formKey.currentState!.validate()) {
                        if (!kDebugMode) {
                          FirebaseAnalytics.instance.logEvent(
                            name: 'login',
                          );
                        }
                        await provider.signInUserWithEmail(_email.text, _password.text, context);
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoute.signupScreen);
                        },
                        child: const Text(
                          "Register here",
                          style: TextStyle(
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
