import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/widgets/ink_well_custom.dart';
import '/components/widgets/toned_btn.dart';
import '/components/widgets/toned_text_field.dart';
import '/providers/auth_service.dart';
import '/style/colors.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController _email = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InkWellCustom(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Consumer<AuthService>(builder: (context, provider, wid) {
          return Form(
            key: _form,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Forgot Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  seTextField(
                      title: 'Email',
                      controller: _email,
                      textInputType: TextInputType.emailAddress,
                      isForm: true,
                      validator: 1,
                      autoFocus: true,
                      hintText: 'abc@xyz.com',
                      focusNode: FocusNode(),
                      onFieldSubmitted: (value) async {
                        if (_form.currentState!.validate()) {
                          await provider.sendChangePasswordLink(email: value);
                        }
                      }),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: TextBtn(
                      width: 200,
                      color: primaryColor,
                      title: 'Send Email',
                      onTap: () async {
                        if (_form.currentState!.validate()) {
                          if (!kDebugMode) {
                            FirebaseAnalytics.instance.logEvent(
                              name: 'forgot_password',
                            );
                          }
                          await provider.sendChangePasswordLink(
                              email: _email.text);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
