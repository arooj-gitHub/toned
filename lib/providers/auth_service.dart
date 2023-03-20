import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as streamChat;
import 'package:tonedaustralia/StripeIntegration/StripePaments.dart';
import 'package:tonedaustralia/main.dart';

import '/components/toned_alerts.dart';
import '/models/user_model.dart';
import '/services/navigation_service.dart';
import '../app_router.dart';
import '../locator.dart';
import 'home_provider.dart';

bool isAdminCreated = false;

class AuthService extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? currentUser;

  streamChat.StreamChatClient? client;
  streamChat.Channel? channel;

  AuthService(this.client);
  // StripePayments stripePayments = StripePayments();

  Future<User?> signInUserWithEmail(String email, password, context) async {
    try {
      EasyLoading.show(status: 'Checking details...');
      UserCredential value = await _auth.signInWithEmailAndPassword(email: email, password: password);
      EasyLoading.dismiss();
      if (value.user != null) {
        String deviceToken = await getToken();
        print("token login");
        print(deviceToken);
        await _firestore.collection("user").doc(value.user!.uid).update({
          "token": deviceToken,
        });

        getUserInfo(value.user!);
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'wrong-password') {
        TonedAlerts().showMessage(context, title: "Invalid password");
        logger.e(e);
      } else if (e.code == 'user-not-found') {
        TonedAlerts().showMessage(context, title: "Invalid email");
      }
    }
    return null;
  }

  Future<void> getUserInfo(User user) async {
    try {
      EasyLoading.show(status: 'Loading...');
      var doc = await _firestore.collection('user').doc(user.uid).get();
      if (doc.exists) {
        EasyLoading.dismiss();
        currentUser = UserModel.fromJson(doc);
        logger.wtf('currentUser -> ${currentUser!.email}');
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        currentUserId = user.uid;
        sharedPreferences.setString("currentUserId", currentUserId);

        bool isAdmin = await checkCurrentUserAdminorNot();
        isAdminCreated = await checkifCreatedfromAdmin();
        if (isAdmin) {
          print("this is called");
          _navigationService.navigateAndRemoveUntilReplace(AppRoute.mainScreen);
          initializeChatStream();
          var provider = Provider.of<HomeProvider>(_navigationService.navigatorKey.currentContext!, listen: false);
          provider.getProgramsAndExercises().then((_) {
            provider.getUserActivities();
          });
        } else {
          int userStatus = await getCurrentUserStatus();
          if (userStatus == 0) {
            print("current status is 0");
            _navigationService.navigateAndRemoveUntilReplace(AppRoute.membership);
          } else if (userStatus == 1) {
            await getcurrentUserSubscribedAtDate();
            await getcurretUserSubscriptionId();

            DateTime currentDate = DateTime.now().add(const Duration(days: 30));
            /*      if (subscribedAt.isAfter(currentDate)) {
              await StripePayments().cancelSubscription2(customerSubscriptionID);
            } else { */
            _navigationService.navigateAndRemoveUntilReplace(AppRoute.mainScreen);
            initializeChatStream();
            var provider = Provider.of<HomeProvider>(_navigationService.navigatorKey.currentContext!, listen: false);
            provider.getProgramsAndExercises().then((_) {
              provider.getUserActivities();
            });
            /*  } */
          } else if (userStatus == 2) {
            EasyLoading.showError('Your account blocked by admin');
          }
        }
      } else {
        _navigationService.navigateAndRemoveUntilReplace(AppRoute.loginScreen);
        EasyLoading.dismiss();
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      logger.e(e);
    }
  }

  Future<User?> signUpUserWithEmail(String email, String password, String name) async {
    try {
      EasyLoading.show(status: 'Checking details...');
      UserCredential value = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      EasyLoading.dismiss();
      if (value.user != null) {
        await addUserInfo(name, email);
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'email-already-in-use') {
        EasyLoading.showInfo('Email already exists');
      } else {
        EasyLoading.showError('Something went wrong');
      }
      logger.e(e);
    }
    notifyListeners();
    return null;
  }

  Future<void> addUserInfo(String name, email) async {
    try {
      EasyLoading.show(status: 'Creating account...');
      User? user = _auth.currentUser;
      if (user != null) {
        await _auth.currentUser!.sendEmailVerification();
        WriteBatch batch = _firestore.batch();

        DocumentReference usersDocRef = _firestore.collection('user').doc(user.uid);
        DocumentReference completedExercisesDocRef = _firestore.collection('user_activities').doc(user.uid);

        batch.set(usersDocRef, {
          'uId': _auth.currentUser!.uid,
          'username': name,
          'email': email,
          'status': 0,
          'CreatedAt': DateTime.now(),
          'isAdmin': false,
          "isCreatedByAdmin": false,
        });

        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        currentUserId = user.uid;
        sharedPreferences.setString("currentUserId", currentUserId);
        batch.set(completedExercisesDocRef, {
          'exercises': null,
          'events': null,
        });

        await batch.commit();
        EasyLoading.dismiss();
        getUserInfo(user);
        // _navigationService.navigateAndRemoveUntilReplace(AppRoute.mainScreen);
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('Something went wrong');
        logger.i('User Empty');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
      _navigationService.navigateAndRemoveUntilReplace(AppRoute.introScreen);
    } catch (e) {
      logger.e(e);
    }
  }

  Future sendChangePasswordLink({String? email}) async {
    try {
      EasyLoading.show(status: 'Loading...');
      await _auth.sendPasswordResetEmail(email: email ?? _auth.currentUser!.email!);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Email sent');
      if (email != null) {
        _navigationService.goBack();
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  Future changeEmailAddress({required String newEmail}) async {
    try {
      EasyLoading.show(status: 'Loading...');
      await _auth.currentUser!.updateEmail(newEmail);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Email updated');
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  Future checkCurrentUser() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (_auth.currentUser != null) {
        print("curret User");
        print(_auth.currentUser);
        await _auth.currentUser!.reload();
        await getUserInfo(_auth.currentUser!);
      } else {
        _navigationService.navigateReplace(AppRoute.introScreen);
      }
    } on FirebaseAuthException catch (e) {
      await _auth.signOut();
      _navigationService.navigateReplace(AppRoute.introScreen);
      logger.e(e);
    }
  }

  Future initializeChatStream() async {
    logger.i('About to established stream chat channel!!!');
    // client = streamChat.StreamChatClient(
    //   '6vxf2zjvks2j',
    //   logLevel: streamChat.Level.INFO,
    // );
    // await client!.connectUser(
    //   streamChat.User(id: 'jee'),
    //   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiamVlIn0.QrvDLfN5V0WN-gVi5MoITfJuGCFeULm1bzz3S03l2Fs',
    // );
    channel = client!.channel(
      'messaging',
      id: 'jee-help',
      extraData: {
        'name': "Jeeali",
        'image': "https://nerdstribe.com/wp-content/uploads/2021/10/nt.jpg",
        "members": ["admin"],
      },
    );

    /// `.watch()` is used to create and listen to the channel for updates. If the
    /// channel already exists, it will simply listen for new events.
    await channel!.watch();
    logger.i('Channel Established!!!');
  }

  getCurrentUserStatus() async {
    int status = 0;
    try {
      await _firestore.collection("user").doc(currentUserId).get().then((value) {
        status = value.get("status") ?? 0;
        print("status from db");
        print(status);
      });
      return status;
    } catch (e) {
      return status;
    }
  }

  checkCurrentUserAdminorNot() async {
    bool isAdmin = false;
    try {
      await _firestore.collection("user").doc(currentUserId).get().then((value) {
        isAdmin = value.get("isAdmin") ?? false;
      });
      return isAdmin;
    } catch (e) {
      return isAdmin;
    }
  }

  checkifCreatedfromAdmin() async {
    bool isAdminCreated = false;
    try {
      await _firestore.collection("user").doc(currentUserId).get().then((value) {
        isAdminCreated = value.get("isCreatedByAdmin") ?? false;
      });
      return isAdminCreated;
    } catch (e) {
      return isAdminCreated;
    }
  }

  getcurretUserSubscriptionId() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('user').doc(currentUser!.uId).get().then(
        (value) {
          customerSubscriptionID = value.get("subscriptionId") ?? "";
        },
      );
    } catch (e) {
      customerSubscriptionID = "";
    }
  }

  getcurrentUserSubscribedAtDate() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('user').doc(currentUser!.uId).get().then(
        (value) {
          subscribedAt = value.get("subscribedAt").toDate();
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  getToken() async {
    String deviceToken = "";
    deviceToken = (await FirebaseMessaging.instance.getToken())!;
    print(deviceToken);
    print("token");
    return deviceToken;
  }
}
