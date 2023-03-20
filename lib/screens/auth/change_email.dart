import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/widgets/ink_well_custom.dart';
import '/components/widgets/toned_btn.dart';
import '/components/widgets/toned_text_field.dart';
import '/providers/auth_service.dart';
import '/style/colors.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
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
                    'Update Email',
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
                        await provider.changeEmailAddress(
                            newEmail: _email.text);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: TextBtn(
                      width: 200,
                      color: primaryColor,
                      title: "Let's go",
                      onTap: () async {
                        if (_form.currentState!.validate()) {
                          if (!kDebugMode) {
                            FirebaseAnalytics.instance.logEvent(
                              name: 'change_email',
                            );
                          }
                          await provider.changeEmailAddress(
                              newEmail: _email.text);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
