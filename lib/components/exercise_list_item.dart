import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/exercise_body.dart';
import '/providers/video_player_provider.dart';
import '/style/styles.dart';

class ExerciseListItem extends StatefulWidget {
  final ExerciseBody exerciseBody;

  const ExerciseListItem({Key? key, required this.exerciseBody})
      : super(key: key);

  @override
  _ExerciseListItemState createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends State<ExerciseListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.exerciseBody.isSpace) ...[
          const SizedBox(height: 10),
        ],
        if (widget.exerciseBody.isVideo) ...[
          InkWell(
            onTap: () => Provider.of<VideoProvider>(context, listen: false)
                .openYouTubeVideo(widget.exerciseBody.videoLink),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.exerciseBody.text,
                  style: smallSubHeadingBold,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Icon(
                  Icons.play_circle_fill,
                ),
              ],
            ),
          ),
        ],
        if (!widget.exerciseBody.isVideo && !widget.exerciseBody.isSpace) ...[
          Text(widget.exerciseBody.text),
        ],

        // Text(
        //   title,
        //   style: headingBold,
        // ),

        // Text(
        //   "Ski/Row/Bike/Run",
        //   style: smallSubHeadingBold,
        // ),
      ],
    );
  }
}
