import 'package:flutter/cupertino.dart';

import '/screens/account_screen.dart';
import '/screens/exercise_lib_screen.dart';
import '/screens/home_screen.dart';
import '../screens/TimerScreens/CountdownTimer_screen.dart';

class BottomNavProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final tonedScreens = [
    const HomeScreen(),
    const ExerciseLib(),
    // const CalenderScreen(),
    const CountdownPage(),
    const AccountScreen(),
  ];

  BottomNavProvider() {
    _currentIndex = 0;
  }
  changeNav(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
