import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '/models/exercise.dart';
import '/models/exercise_body.dart';
import '/models/group.dart';
import '/models/program.dart';
import '/providers/auth_service.dart';
import '/services/navigation_service.dart';
import '../locator.dart';

class HomeProvider with ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();
  late FirebaseFirestore _firestore;
  late Program selectedProgram;
  late Exercise selectedExercise;

  /// 0=LOADING | 1=SUCCESS | 2=NO_DATA | 3=NO_GROUP_ASSIGNED
  int isLoading = 0;
  List completedExercisesList = [], userEvents = [];
  int lastIndex = 0;

  Group? groupProgramExercise;

  HomeProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  void changeSelectedProgram(int index) {
    selectedProgram = groupProgramExercise!.programsList![index];
    lastIndex = 0;
    notifyListeners();
  }

  Future getProgramsAndExercises() async {
    try {
      final userModel = Provider.of<AuthService>(_navigationService.navigatorKey.currentContext!, listen: false).currentUser;
      logger.wtf('STARTED');
      if (userModel != null) {
        if (userModel.group!.isNotEmpty) {
          logger.wtf('user_group -> ${userModel.group}');
          var groupDoc = await _firestore.collection('groups').doc(userModel.group).get();
          if (groupDoc.exists) {
            if (groupDoc.data()!['status'] == 1) {
              print("group status");
              print(groupDoc.data()!['status']);
              List<Program> programsList = [];
              List<Exercise> exercisesList = [];
              groupProgramExercise = Group.fromJson(groupDoc);
              print("group id is --------------------------------------->");
              print(userModel.group);
              var programsDoc = await _firestore.collection('programs').where('group_id', isEqualTo: userModel.group).where('status', isEqualTo: 1).get();
              if (programsDoc.docs.isNotEmpty) {
                for (int i = 0; i < programsDoc.docs.length; i++) {
                  programsList.add(Program.fromJson(programsDoc.docs[i]));
                  print("programs list");
                  print(programsList.length);
                  await _firestore.collection('exercises').get().then((value) {
                    for (var i in value.docs) {
                      i.data();
                    }
                  });
                  var exercisesDoc = await _firestore.collection('exercises').where('program_id', isEqualTo: programsDoc.docs[i].id).where('status', isEqualTo: 1).get();
                  if (exercisesDoc.docs.isNotEmpty) {
                    for (int j = 0; j < exercisesDoc.docs.length; j++) {
                      exercisesList.add(Exercise.fromJson(exercisesDoc.docs[j]));
                    }
                    programsList[i].exercisesList = exercisesList;
                    exercisesList = [];
                    isLoading = 1;
                  } else {
                    /// no exercises
                    logger.wtf('no exercises');
                    isLoading = 2;
                  }
                }
                groupProgramExercise!.programsList = programsList;
                logger.wtf('group -> ${groupProgramExercise!.title}');
                selectedProgram = groupProgramExercise!.programsList!.first;
                if (selectedProgram.exercisesList!.isNotEmpty) {
                  getExerciseBody(0);
                }
                notifyListeners();
              } else {
                /// no programs
                logger.wtf('no programs');
                isLoading = 2;
                notifyListeners();
              }
            } else {
              /// group deleted
              logger.wtf('group deleted');
              isLoading = 2;
            }
          } else {
            /// empty group
            logger.wtf('empty group');
            isLoading = 2;
          }
        } else {
          logger.wtf('group not assigned');
          isLoading = 3;
        }
      } else {
        logger.wtf('userModel is empty');
        isLoading = 3;
      }
      notifyListeners();
    } catch (e) {
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  Future getExerciseBody(int index) async {
    try {
      if (!EasyLoading.isShow) {
        logger.wtf('getExerciseBody started');
        List<ExerciseBody> exerciseBodyList = [];
        EasyLoading.show(status: 'Loading...');
        logger.i('id -> ${selectedProgram.exercisesList![index].id}');
        var exercisesDoc = await _firestore.collection('exercises').doc(selectedProgram.exercisesList![index].id).collection('body').doc('body').get();
        if (exercisesDoc.exists) {
          logger.i('getExerciseBody exists');
          List body = exercisesDoc.data()!['body'];
          for (int i = 0; i < body.length; i++) {
            exerciseBodyList.add(ExerciseBody.fromJson(body[i]));
          }
          selectedProgram.exercisesList![index].exerciseBody = exerciseBodyList;
          logger.wtf('_exerciseBodyList -> ${exerciseBodyList.length}');
          if (selectedProgram.exercisesList![index].exerciseBody != null) {
            for (int j = 0; j < selectedProgram.exercisesList![index].exerciseBody!.length; j++) {
              logger.wtf('selectedProgram.exercisesList![index].exerciseBody -> ${selectedProgram.exercisesList![index].exerciseBody![j].text}');
            }
          }
          notifyListeners();
          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
          logger.i('No exercise body');
        }
      } else {
        logger.wtf('***** Still Loading *****');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  Future completeSession(String exerciseId, String programId, bool isAlreadyCompleted) async {
    try {
      EasyLoading.show(status: 'Loading...');
      final userModel = Provider.of<AuthService>(_navigationService.navigatorKey.currentContext!, listen: false).currentUser;
      if (userModel != null) {
        WriteBatch batch = _firestore.batch();

        DocumentReference completedSessionsDocRef = _firestore.collection('user_activities').doc(userModel.uId);
        DocumentReference userDocRef = _firestore.collection('user').doc(userModel.uId);

        if (isAlreadyCompleted) {
          batch.update(completedSessionsDocRef, {
            'exercises': FieldValue.arrayRemove([exerciseId]),
          });
        } else {
          batch.update(completedSessionsDocRef, {
            'exercises': FieldValue.arrayUnion([exerciseId]),
          });
        }
        batch.update(userDocRef, {
          'last_exercise': exerciseId,
          'last_program': programId,
        });

        await batch.commit();
        EasyLoading.dismiss();

        getUserActivities();
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError('Something went wrong');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  Future getUserActivities() async {
    try {
      completedExercisesList = [];
      userEvents = [];
      logger.i('completedExercisesList -> STARTED');
      final userModel = Provider.of<AuthService>(_navigationService.navigatorKey.currentContext!, listen: false).currentUser;
      if (userModel != null) {
        DocumentSnapshot<Map<String, dynamic>> userActivities = await _firestore.collection('user_activities').doc(userModel.uId).get();
        if (userActivities.exists) {
          logger.i('completedExercisesList -> EXISTS');
          if (userActivities.data() != null) {
            if (userActivities.data()!['exercises'] != null) {
              completedExercisesList = userActivities.data()!['exercises'];
            }
            if (userActivities.data()!['events'] != null) {
              userEvents = userActivities.data()!['events'];
            }
            logger.i('completedExercisesList -> ${completedExercisesList.length}');
          }
        }
        notifyListeners();
      }
    } catch (e) {
      logger.e(e);
      // EasyLoading.showError('Something went wrong');
    }
  }

  bool checkIfExerciseIsCompleted(String exerciseId) {
    bool isThere = false;
    for (int i = 0; i < completedExercisesList.length; i++) {
      if (completedExercisesList[i].toString().contains(exerciseId)) {
        isThere = true;
        break;
      }
    }
    return isThere;
  }
}
