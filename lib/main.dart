import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tonedaustralia/providers/payment_provider.dart';

import '/providers/home_provider.dart';
import '/providers/video_player_provider.dart';
import 'NotificationController/NotificationController.dart';
import 'app_router.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'providers/auth_service.dart';
import 'providers/bottom_nav_provider.dart';
import 'providers/events_provider.dart';
import 'providers/exercise_library_provider.dart';
import 'services/navigation_service.dart';
import 'style/colors.dart';

String currentUserId = "";
RemoteMessage? eventOfNotification;
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {
  // x();
}
/* FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("FCM firebaseMessagingBackgroundHandler  OR ${message.data}");
  }
} */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationController notificationController = NotificationController();
  await notificationController.checkPermission();
  await notificationController.initializeLocalNotifications();
  await FirebaseMessaging.instance.subscribeToTopic('all');
  // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /* LocalNotification.initialize(flutterLocalNotificationsPlugin!);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  final bool? result = await flutterLocalNotificationsPlugin
      ?.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  FirebaseMessaging.onMessage.listen(FCMService.receiveForegroundNotification);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler); */

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print("initial message called");

    eventOfNotification = initialMessage;
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print(message.messageId);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("on app mesage id");
    print(message.messageId);
  });

  final client = StreamChatClient(
    '6vxf2zjvks2j',
    logLevel: Level.INFO,
  );
  await client.connectUser(
    User(id: 'jee'),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiamVlIn0.QrvDLfN5V0WN-gVi5MoITfJuGCFeULm1bzz3S03l2Fs',
  );

  /// TODO: check if this line is useful.
  Provider.debugCheckInvalidValueType = null;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // runApp(MyApp(client: client));
  await runZonedGuarded(
    () async => runApp(MyApp(client: client)),
    (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    },
  );
  configLoading();
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;
  const MyApp({Key? key, required this.client}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final streamChatTheme = ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
      primaryColor: primaryColor,
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EventsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExerciseLibraryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(client),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaymentProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Toned Australia',
        theme: lightTheme,
        initialRoute: AppRoute.wrapperScreen,
        onGenerateRoute: AppRoute.generateRoute,

        navigatorKey: locator<NavigationService>().navigatorKey,
        // builder: EasyLoading.init(),
        builder: (context, widget) {
          widget = StreamChat(
            client: client,
            streamChatThemeData: StreamChatThemeData.fromTheme(streamChatTheme),
            child: widget,
          );
          widget = EasyLoading.init()(context, widget);
          return widget;
        },
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1200)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..dismissOnTap = false
    ..userInteractions = false;
  // ..customAnimation = CustomAnimation();
}
