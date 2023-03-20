import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/widgets/ink_well_custom.dart';
import '/components/widgets/toned_btn.dart';
import '/components/widgets/toned_text_field.dart';
import '/providers/auth_service.dart';
import '/style/colors.dart';
import '../../app_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late FocusNode _emailNode, _passNode, _nameNode;

  @override
  void initState() {
    super.initState();
    _emailNode = FocusNode();
    _passNode = FocusNode();
    _nameNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailNode.dispose();
    _passNode.dispose();
    _nameNode = FocusNode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (BuildContext context, authProvider, Widget? child) {
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 28),
                        child: Text(
                          'Register',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          seTextField(
                            title: 'Name',
                            controller: _name,
                            isForm: true,
                            validator: 0,
                            hintText: 'Arnold Schwarzenegger',
                            focusNode: _nameNode,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.name,
                            onFieldSubmitted: (val) =>
                                _emailNode.requestFocus(),
                          ),
                          seTextField(
                            title: 'Email',
                            controller: _email,
                            validator: 1,
                            isForm: true,
                            hintText: 'abc@xyz.com',
                            focusNode: _emailNode,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                            onFieldSubmitted: (val) => _passNode.requestFocus(),
                          ),
                          seTextField(
                            title: 'Password',
                            controller: _password,
                            bottomPadding: 18,
                            obscure: true,
                            validator: 2,
                            isForm: true,
                            hintText: '6HNx^44k1',
                            focusNode: _passNode,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.visiblePassword,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "By registering, you agree to Toned AU's\n",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Terms of Use",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: " and ",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextBtn(
                    width: 200,
                    color: primaryColor,
                    title: 'Signup',
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (!kDebugMode) {
                          FirebaseAnalytics.instance.logEvent(
                            name: 'signup',
                          );
                        }
                        await authProvider.signUpUserWithEmail(
                            _email.text, _password.text, _name.text);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!kDebugMode) {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'already_have_an_account',
                              );
                            }
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushNamed(
                                  context, AppRoute.loginScreen);
                            }
                          },
                          child: const Text(
                            "Login here",
                            style: TextStyle(
                              color: primaryColor,
                              decoration: TextDecoration.underline,
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
        );
      },
    );
  }
}
