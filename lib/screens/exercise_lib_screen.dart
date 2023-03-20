import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/widgets/ink_well_custom.dart';
import '/components/widgets/toned_illustration.dart';
import '/models/exercise_library.dart';
import '/providers/exercise_library_provider.dart';
import '/providers/video_player_provider.dart';
import '/utils/constants.dart';

class ExerciseLib extends StatefulWidget {
  const ExerciseLib({Key? key}) : super(key: key);

  @override
  _ExerciseLibState createState() => _ExerciseLibState();
}

class _ExerciseLibState extends State<ExerciseLib> {

  @override
  void initState() {
    var _provider = Provider.of<ExerciseLibraryProvider>(context, listen: false);
    if(_provider.exercisesList.isEmpty){
    _provider.getExercisesLibrary();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ExerciseLibraryProvider>(
      builder: (context, provider, wid) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text(
              "Exercise Library",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          body: InkWellCustom(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoSearchTextField(
                      onChanged: (query) {
                        List<ExerciseLibrary> dummySearchList = provider.duplicateExercisesList;
                        List<ExerciseLibrary> dummySearchListData = [];
                        if (query.isNotEmpty) {
                          debugPrint('query.isNotEmpty');
                          for (int i = 0; i < dummySearchList.length; i++) {
                            if (dummySearchList[i].title
                                .toLowerCase()
                                .contains(query.toLowerCase())) {
                              dummySearchListData.add(dummySearchList[i]);
                            }
                          }
                          setState(() {
                            provider.exercisesList = [];
                            provider.exercisesList = dummySearchListData;
                          });
                          return;
                        } else {
                          debugPrint('query.isEmpty');
                          setState(() {
                            provider.exercisesList = [];
                            provider.exercisesList = provider.duplicateExercisesList;
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: provider.exercisesList.isNotEmpty ? ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            provider.exercisesList[index].title,
                            style: const TextStyle(fontSize: 20),
                          ),
                          onTap: () {
                            Provider.of<VideoProvider>(context, listen: false)
                                .openYouTubeVideo(provider.exercisesList[index].url);
                          },
                        );
                      },
                      itemCount: provider.exercisesList.length,
                    ) : const TonedIllustration(
                      text: 'No exercise found',
                      asset: TonedAssets.rest,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
