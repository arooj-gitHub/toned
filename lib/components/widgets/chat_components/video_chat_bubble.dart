import 'dart:ui';

import 'package:flutter/material.dart';

class VideoChatBubble extends StatelessWidget {
  final bool isSender;

  const VideoChatBubble({Key? key, required this.isSender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(
            right: isSender ? size.width / 4 : 8,
            left: isSender ? 8 : size.width / 4),
        child: Card(
          color: isSender ? Colors.grey.shade100 : Colors.indigo.shade400,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(22),
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/2.png',
                width: 111,
                height: 150,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.play_circle_filled_rounded,
                      color: Theme.of(context).colorScheme.background,
                      size: 28,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        height: 20,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.1),
                        ),
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              const Text(
                                '2:00 AM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              if (!isSender) ...[
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.done_all_rounded,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
