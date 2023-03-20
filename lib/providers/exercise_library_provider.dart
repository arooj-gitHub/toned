import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import '/models/exercise_library.dart';
import '/services/navigation_service.dart';

import '../locator.dart';

class ExerciseLibraryProvider with ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();
  late FirebaseFirestore _firestore;
  List<ExerciseLibrary> exercisesList = [], duplicateExercisesList = [];

  ExerciseLibraryProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  Future getExercisesLibrary() async {
    try {
      EasyLoading.show(status: 'Loading...');
      var exercisesDocs = await _firestore
          .collection('library')
          .orderBy('title', descending: false)
          .where('status', isEqualTo: 1)
          .get();
      if (exercisesDocs.docs.isNotEmpty) {
        List docsList = exercisesDocs.docs;
        for (int i = 0; i < docsList.length; i++) {
          exercisesList.add(ExerciseLibrary.fromJson(exercisesDocs.docs[i]));
        }
        duplicateExercisesList = exercisesList;
        notifyListeners();
        EasyLoading.dismiss();
      } else {
        /// No Exercises
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }
}
