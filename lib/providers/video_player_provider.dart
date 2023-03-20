import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '/services/navigation_service.dart';

import '../locator.dart';

class VideoProvider with ChangeNotifier {
  // late YoutubePlayerController youtubePlayerController;
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();

  openYouTubeVideo(String videoUrl) {
    String? videoId;
    // videoId = YoutubePlayerController.convertUrlToId(videoUrl);
    // debugPrint('videoId -> $videoId'); // BBAyRBTfsOU
    // youtubePlayerController = YoutubePlayerController(
    //   initialVideoId: videoId!,
    //   params: const YoutubePlayerParams(
    //     autoPlay: true,
    //     showFullscreenButton: true,
    //     strictRelatedVideos: true,
    //   ),
    // );
    // _navigationService.navigateTo(AppRoute.videoPlayer);
  }

  bindWidget() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // youtubePlayerController;
    });
  }

  closeController() {
    try {
      // youtubePlayerController.close();
    } catch (e) {
      logger.e(e);
    }
  }

  buildVideoPreview() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(),

      /// remove later
      // child: YoutubePlayerIFrame(
      //   controller: youtubePlayerController,
      // ),
    );
    notifyListeners();
  }

  void playVideo() {
    // Future.delayed(Duration(milliseconds: 2000)).then((value){
    //   youtubePlayerController.play();
    //   youtubePlayerController.onEnterFullscreen = (){
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.landscapeRight,
    //       DeviceOrientation.landscapeLeft,
    //     ]);
    //   };
    //   youtubePlayerController.onExitFullscreen = (){
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.portraitUp,
    //       DeviceOrientation.portraitDown,
    //     ]);
    //   };
    // });
  }
}
