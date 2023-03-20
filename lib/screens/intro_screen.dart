import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/app_router.dart';
import '/components/widgets/toned_btn.dart';
import '/style/colors.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  double btnSize = double.infinity;
  int currentPageValue = 0;
  final pageController = PageController(
    initialPage: 0,
  );
  final introTitle = [
    'Toned Australia',
    'Get Fit',
    '#TONEDAU',
  ];
  final introSubTitle = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
  ];
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            onPageChanged: (int page) {
              getChangedPageAndMoveBar(page);
            },
            controller: pageController,
            children: [
              bgContainer(
                size: _size,
                img: 'assets/images/1.png',
              ),
              bgContainer(
                size: _size,
                img: 'assets/images/2.png',
              ),
              bgContainer(
                size: _size,
                img: 'assets/images/3.png',
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(70),
                topLeft: Radius.circular(70),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  height: _size.height / 2.6,
                  width: _size.width,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 26,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              introTitle[currentPageValue],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              introSubTitle[currentPageValue],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < introTitle.length; i++)
                            if (i == currentPageValue) ...[circleBar(true)] else
                              circleBar(false),
                        ],
                      ),
                      Column(
                        children: [
                          TextBtn(
                              width: btnSize,
                              title: "Create Account",
                              onTap: () {
                                if (!kDebugMode) {
                                  FirebaseAnalytics.instance.logEvent(
                                    name: 'signup_page',
                                  );
                                }
                                Navigator.pushReplacementNamed(
                                    context, AppRoute.signupScreen);
                              }),
                          const SizedBox(height: 10),
                          TextBtn(
                              width: btnSize,
                              color: Colors.white,
                              title: "Login",
                              onTap: () {
                                if (!kDebugMode) {
                                  FirebaseAnalytics.instance.logEvent(
                                    name: 'login',
                                  );
                                }
                                Navigator.pushReplacementNamed(
                                    context, AppRoute.loginScreen);
                              }
//
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bgContainer({required Size size, required String img}) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage(
            img,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: size.height / 2,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black38,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 7,
      width: 7,
      decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}
