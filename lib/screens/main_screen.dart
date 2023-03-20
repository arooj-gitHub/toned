import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '/providers/bottom_nav_provider.dart';
import '/style/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (BuildContext context, navProvider, Widget? child) {
        return Scaffold(
          body: navProvider.tonedScreens[navProvider.currentIndex],
          bottomNavigationBar: SafeArea(
            child: SalomonBottomBar(
              onTap: (index) {
                if (!kDebugMode) {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'bottom_nav_bar_$index',
                  );
                }
                setState(() {
                  navProvider.changeNav(index);
                });
              },
              currentIndex: navProvider.currentIndex,
              items: [
                SalomonBottomBarItem(
                  icon: const Icon(Icons.home_rounded, size: 18),
                  title: const Text(
                    "Program",
                    style: TextStyle(fontSize: 12),
                  ),
                  selectedColor: primaryColor,
                ),

                /// Library
                SalomonBottomBarItem(
                  icon: const Icon(Icons.local_library, size: 18),
                  title: const Text(
                    "Exercise library",
                    style: TextStyle(fontSize: 12),
                  ),
                  selectedColor: primaryColor,
                ),

                // timer
                SalomonBottomBarItem(
                  icon: const Icon(Icons.timer, size: 18),
                  title: const Text(
                    "Timer",
                    style: TextStyle(fontSize: 12),
                  ),
                  selectedColor: primaryColor,
                ),

                /// Account
                SalomonBottomBarItem(
                  icon: const Icon(Icons.person, size: 18),
                  title: const Text(
                    "Account",
                    style: TextStyle(fontSize: 12),
                  ),
                  selectedColor: primaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
