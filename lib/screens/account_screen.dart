import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tonedaustralia/main.dart';
import 'package:tonedaustralia/screens/cancel_subscription.dart';

import '/app_router.dart';
import '/components/toned_alerts.dart';
import '/components/widgets/account_list_tIle.dart';
import '/components/widgets/account_setting_tIle.dart';
import '/providers/auth_service.dart';
import '../StripeIntegration/StripePaments.dart';
import 'chat/stream_schat_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, provider, wid) {
      return Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(bottom: 12, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.asset(
                            'assets/images/me.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // ignore: prefer_const_constructors
                        Text(
                          provider.currentUser!.name!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          provider.currentUser!.email!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Account
                  const accountSettingTitle(title: 'Account'),
                  Column(
                    children: [
                      AccountListTile(
                          title: 'CHANGE EMAIL',
                          icon: const Icon(CupertinoIcons.mail),
                          onTap: () {
                            if (!kDebugMode) {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'change_email',
                              );
                            }
                            Navigator.pushNamed(context, AppRoute.changeEmail);
                          }),
                      AccountListTile(
                        title: 'CHANGE PASSWORD',
                        icon: const Icon(CupertinoIcons.pen),
                        onTap: () {
                          // changePass(context);
                          TonedAlerts().ask(
                            context,
                            title: 'Do you want to change password?',
                            func: () {
                              Navigator.pop(context);
                              provider.sendChangePasswordLink();
                              if (!kDebugMode) {
                                FirebaseAnalytics.instance.logEvent(
                                  name: 'change_password',
                                );
                              }
                            },
                            cancelFunc: () => Navigator.pop(context),
                            isDismissible: true,
                            isComplexText: true,
                            complexText: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Do you want to change password?',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'An email will be sent to your inbox with a password reset link',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      AccountListTile(
                          title: 'MANAGE PLAN',
                          icon: const Icon(CupertinoIcons.pencil_ellipsis_rectangle),
                          onTap: () {
                            if (!kDebugMode) {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'manage_plan',
                              );
                            }
                          }),
                    ],
                  ),

                  /// General
                  const accountSettingTitle(title: 'General'),
                  Column(
                    children: [
                      AccountListTile(
                          title: 'PERSONAL INFOMATION',
                          icon: const Icon(CupertinoIcons.person_alt),
                          onTap: () {
                            if (!kDebugMode) {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'personal_information',
                              );
                            }
                          }),
                      AccountListTile(
                          title: 'Calendar',
                          icon: const Icon(Icons.calendar_today, size: 18),
                          onTap: () {
                            if (!kDebugMode) {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'Calendar Information',
                              );
                            }
                          }),
                      AccountListTile(
                          title: 'PUSH NOTIFICATIONS',
                          icon: const Icon(CupertinoIcons.rectangle_on_rectangle),
                          onTap: () {
                            if (!kDebugMode) {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'push_notification',
                              );
                            }
                          }),
                      customerSubscriptionID != "" && isAdminCreated == false
                          ? AccountListTile(
                              title: 'Cancel Subscription',
                              icon: const Icon(CupertinoIcons.rectangle_on_rectangle),
                              onTap: () {
                                if (!kDebugMode) {
                                  FirebaseAnalytics.instance.logEvent(
                                    name: 'cancel_subscription',
                                  );
                                }
                                Navigator.push(context, PageViewTransition(builder: (_) => const CancelSubscription()));
                              },
                            )
                          : Container(),
                    ],
                  ),

                  /// Track
                  const accountSettingTitle(title: 'Track'),
                  Column(
                    children: [
                      AccountListTile(
                          title: 'PROGRESS',
                          icon: const Icon(CupertinoIcons.waveform_path_ecg),
                          onTap: () {
                            if (!kDebugMode) {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'progress',
                              );
                            }
                          }),
                    ],
                  ),
                  const accountSettingTitle(title: 'Contact Us'),
                  AccountListTile(
                    title: 'CHAT',
                    icon: const Icon(CupertinoIcons.bubble_left_bubble_right),
                    // onTap: () => Navigator.pushNamed(context, AppRoute.chatScreen),
                    onTap: () {
                      if (!kDebugMode) {
                        FirebaseAnalytics.instance.logEvent(
                          name: 'chat',
                        );
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StreamChannel(channel: provider.channel!, child: const StreamChatScreen())),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'logout',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: const Icon(Icons.logout),
                    minLeadingWidth: 22,
                    onTap: () async {
                      TonedAlerts().ask(
                        context,
                        title: 'Do you want to logout?',
                        func: () {
                          if (!kDebugMode) {
                            FirebaseAnalytics.instance.logEvent(
                              name: 'logout',
                            );
                          }
                          provider.signOutUser();
                        },
                        cancelFunc: () => Navigator.pop(context),
                        isDismissible: true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  getUserAdminStatus() async {
    bool isAdmin = false;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc = await firestore.collection('user').doc(currentUserId).get();
    if (doc.get("isAdmin")) {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
    return isAdmin;
  }
}
