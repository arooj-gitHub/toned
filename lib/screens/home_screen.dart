import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/exercise_list_item.dart';
import '/components/widgets/home/home_appbar.dart';
import '/components/widgets/toned_illustration.dart';
import '/models/exercise.dart';
import '/models/exercise_body.dart';
import '/providers/home_provider.dart';
import '/style/colors.dart';
import '/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, wid) {
        return Column(
          children: [
            /// SUCCESS
            if (provider.isLoading == 1) ...[
              if (provider.selectedProgram.exercisesList != null) ...[
                Expanded(
                  child: DefaultTabController(
                    length: provider.selectedProgram.exercisesList != null ? provider.selectedProgram.exercisesList!.length : 0,
                    initialIndex: provider.lastIndex,
                    child: Builder(builder: (context) {
                      TabController? tabController = DefaultTabController.of(context);
                      tabController.addListener(() {
                        if (!tabController.indexIsChanging) {
                          // Your code goes here.
                          // To get index of current tab use tabController.index
                          debugPrint('tabController.index -> ${tabController.index}');
                          provider.lastIndex = tabController.index;
                          if (provider.selectedProgram.exercisesList![tabController.index].exerciseBody == null) {
                            provider.getExerciseBody(tabController.index);
                          }
                          setState(() {});
                        }
                      });
                      bool exerciseCompleted = false;
                      exerciseCompleted = provider.checkIfExerciseIsCompleted(provider.selectedProgram.exercisesList![tabController.index].id);
                      return Scaffold(
                        appBar: homeAppBar(context, provider, withoutTabs: false),
                        body: CupertinoPageScaffold(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 8),
                              Expanded(
                                child: TabBarView(
                                  children: provider.selectedProgram.exercisesList!.map((Exercise exercise) {
                                    if (exercise.exerciseBody != null) {
                                      return ListView(
                                        children: exercise.exerciseBody!.map((ExerciseBody exerciseBody) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: ExerciseListItem(exerciseBody: exerciseBody),
                                          );
                                        }).toList(),
                                      );
                                    } else {
                                      return const TonedIllustration(
                                        text: 'No exercise for now',
                                        asset: TonedAssets.wait,
                                      );
                                    }
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        bottomNavigationBar: SizedBox(
                          width: double.infinity,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            decoration: BoxDecoration(
                              color: exerciseCompleted ? successColor : primaryColor,
                            ),
                            child: FloatingActionButton.extended(
                              elevation: 0,
                              shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                              // backgroundColor:
                              // exerciseCompleted
                              //         ? successColor
                              //         : primaryColor,
                              splashColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              onPressed: () {
                                provider.completeSession(provider.selectedProgram.exercisesList![tabController.index].id, provider.selectedProgram.id, exerciseCompleted);
                              },
                              label: exerciseCompleted
                                  ? const Text(
                                      "COMPLETED",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text("COMPLETE SESSION"),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(CupertinoIcons.checkmark_alt),
                                      ],
                                    ),
                              heroTag: null,
                              // heroTag: provider.selectedProgram.exercisesList![tabController.index].id,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
              if (provider.selectedProgram.exercisesList == null) ...[
                Expanded(
                  child: Scaffold(
                    appBar: homeAppBar(context, provider, withoutTabs: true),
                    body: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const TonedIllustration(
                        text: 'No exercise for now',
                        asset: TonedAssets.wait,
                      ),
                    ),
                  ),
                ),
              ],
            ],

            /// LOADING
            if (provider.isLoading == 0) ...[
              Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text(
                      'HANG ON',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                  body: Stack(
                    children: const [
                      Align(
                        alignment: Alignment.topCenter,
                        child: LinearProgressIndicator(),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TonedIllustration(
                          text: 'Curating your home screen',
                          asset: TonedAssets.meditation,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            /// NO_DATA
            if (provider.isLoading == 2) ...[
              Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                  ),
                  body: Stack(
                    children: const [
                      Align(
                        alignment: Alignment.center,
                        child: TonedIllustration(
                          text: 'Your exercise list is empty!',
                          asset: TonedAssets.change,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            /// NO_GROUP_ASSIGNED
            if (provider.isLoading == 3) ...[
              Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                  ),
                  body: Stack(
                    children: const [
                      Align(
                        alignment: Alignment.center,
                        child: TonedIllustration(
                          text: 'No program/exercises assigned yet!',
                          asset: TonedAssets.change,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
