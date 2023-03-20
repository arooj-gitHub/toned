import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '/components/toned_alerts.dart';
import '/models/event.dart';
import '/providers/home_provider.dart';
import '/services/navigation_service.dart';

import '../locator.dart';
import 'auth_service.dart';

class EventsProvider with ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();
  late FirebaseFirestore _firestore;

  DateTime selectedDate = DateTime.now();

  EventsProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  ///! EVENTS PAGINATION
  //#region

  List<EventModel> eventsList = [];

  bool hasMoreEvents = true; // flag for more docs available or not
  DocumentSnapshot? lastEventsDocument;

  bool eventsLoading = false;

  void clearEventsList() {
    hasMoreEvents = true;
    eventsList = [];
    lastEventsDocument = null;
  }

  Future getEvents() async {
    try {
      if (eventsLoading || !hasMoreEvents) {
        logger.wtf('Loading or No More Events');
        return;
      }
      eventsLoading = true;
      notifyListeners();

      Query query = _firestore
          .collection('events')
          .where('event_date',
              isEqualTo:
                  "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}")
          .where('status', isEqualTo: 1)
          .orderBy('event_timestamp', descending: false)
          .limit(10);
      QuerySnapshot querySnapshot;
      if (lastEventsDocument == null) {
        querySnapshot = await query.get();
      } else {
        querySnapshot =
            await query.startAfterDocument(lastEventsDocument!).get();
      }
      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.length < 10) hasMoreEvents = false;
        lastEventsDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((doc) {
          logger.wtf('Event Doc -> ${doc.data()}');
          eventsList.add(EventModel.fromJson(doc));
        });
      } else {
        hasMoreEvents = false;
      }
      eventsLoading = false;
      notifyListeners();
    } catch (err) {
      logger.e('$err');
    }
  }

  Future attendEvent(EventModel event) async {
    try {
      EasyLoading.show(status: 'Loading...');
      final userModel = Provider.of<AuthService>(
          _navigationService.navigatorKey.currentContext!,
          listen: false)
          .currentUser;
      if (userModel != null) {
        WriteBatch batch = _firestore.batch();

        DocumentReference eventDocRef =
        _firestore.collection('events').doc(event.id);
        DocumentReference eventAttendeesDocRef =
        _firestore.collection('event_attendees').doc(event.id);
        DocumentReference userEventAttendingDocRef =
        _firestore.collection('user_activities').doc(userModel.uId);

        batch.update(eventDocRef, {
          'attendees': FieldValue.increment(1),
        });
        batch.update(eventAttendeesDocRef, {
          'attendees': FieldValue.arrayUnion([userModel.uId]),
        });
        batch.update(userEventAttendingDocRef, {
          'events': FieldValue.arrayUnion([event.id]),
        });

        await batch.commit();
        EasyLoading.dismiss();
        Provider.of<HomeProvider>(
            _navigationService.navigatorKey.currentContext!,
            listen: false)
            .getUserActivities();
        TonedAlerts().showMessage(
          _navigationService.navigatorKey.currentContext!,
          title: 'Done!',
          subTitle: 'You are attending ${event.title}',
        );
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('Uh-Oh! Try again');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  Future neglectEvent(EventModel event) async {
    try {
      EasyLoading.show(status: 'Loading...');
      final userModel = Provider.of<AuthService>(
          _navigationService.navigatorKey.currentContext!,
          listen: false)
          .currentUser;
      if (userModel != null) {
        WriteBatch batch = _firestore.batch();

        DocumentReference eventDocRef =
        _firestore.collection('events').doc(event.id);
        DocumentReference eventAttendeesDocRef =
        _firestore.collection('event_attendees').doc(event.id);
        DocumentReference userEventAttendingDocRef =
        _firestore.collection('user_activities').doc(userModel.uId);

        batch.update(eventDocRef, {
          'attendees': FieldValue.increment(-1),
        });
        batch.update(eventAttendeesDocRef, {
          'attendees': FieldValue.arrayRemove([userModel.uId]),
        });
        batch.update(userEventAttendingDocRef, {
          'events': FieldValue.arrayRemove([event.id]),
        });

        await batch.commit();
        EasyLoading.dismiss();
        Provider.of<HomeProvider>(
            _navigationService.navigatorKey.currentContext!,
            listen: false)
            .getUserActivities();
        TonedAlerts().showMessage(
          _navigationService.navigatorKey.currentContext!,
          title: 'Uh-Oh!',
          subTitle: 'You selected not to attend ${event.title}',
        );
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('Uh-Oh! Try again');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

//#endregion

}
