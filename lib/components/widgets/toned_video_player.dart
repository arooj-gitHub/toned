import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/providers/video_player_provider.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  void initState() {
    super.initState();
    // _setOrientation([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    Provider.of<VideoProvider>(context, listen: false).bindWidget();
    Provider.of<VideoProvider>(context, listen: false).playVideo();
  }

  @override
  void dispose() {
    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    try {
      Provider.of<VideoProvider>(context, listen: false).closeController();
    } catch (e) {
      debugPrint('e -> $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
              children: [
                provider.buildVideoPreview(),
              ],
            ),
          ),
        );
      },
    );
  }
}
