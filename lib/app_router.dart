import 'package:flutter/material.dart';
import 'package:tonedaustralia/screens/MemberShip.dart';
import 'package:tonedaustralia/screens/Subscription/card_details.dart';
import 'package:tonedaustralia/screens/TimerScreens/CountdownTimer_screen.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/components/widgets/toned_video_player.dart';
import 'screens/auth/change_email.dart';
import 'screens/auth/forgot_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/main_screen.dart';
import 'screens/wrapper_screen.dart';

class PageViewTransition<T> extends MaterialPageRoute<T> {
  PageViewTransition({required WidgetBuilder builder, RouteSettings? settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//    if (settings.isInitialRoute) return child;
    if (animation.status == AnimationStatus.reverse) {
      return super.buildTransitions(context, animation, secondaryAnimation, child);
    }
    return FadeTransition(opacity: animation, child: child);
  }
}

class AppRoute {
  static const String wrapperScreen = '/';
  static const String introScreen = '/intro';
  static const String loginScreen = '/login';
  static const String mainScreen = '/main';
  static const String timerUi = '/timerUi';

  static const String signupScreen = '/signup';
  static const String forgotScreen = '/forget';
  static const String changeEmail = '/ChangeEmail';
  static const String videoPlayer = '/videoPlayer';
  static const String cardView = '/cardView';
  static const String membership = '/membership';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case wrapperScreen:
        return PageViewTransition(builder: (_) => const Wrapper());
      case introScreen:
        return PageViewTransition(builder: (_) => const IntroScreen());
      case forgotScreen:
        return PageViewTransition(builder: (_) => const ForgotScreen());
      case signupScreen:
        return PageViewTransition(builder: (_) => const SignupScreen());
      case loginScreen:
        return PageViewTransition(builder: (_) => const LoginScreen());
      case mainScreen:
        return PageViewTransition(builder: (_) => const MainScreen());
      case timerUi:
        return PageViewTransition(builder: (_) => const CountdownPage());
      case changeEmail:
        return PageViewTransition(builder: (_) => const ChangeEmail());
      case videoPlayer:
        return PageViewTransition(builder: (_) => const VideoPlayer());
      case cardView:
        return PageViewTransition(builder: (_) => CardDetails(amount: ""));
      case membership:
        return PageViewTransition(builder: (_) => const MemberShip());
      default:
        return PageViewTransition(builder: (_) => const IntroScreen());
    }
  }
}
