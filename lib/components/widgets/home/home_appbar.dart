import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '/models/exercise.dart';
import '/providers/auth_service.dart';
import '/providers/home_provider.dart';
import '/screens/chat/stream_schat_screen.dart';
import '/style/styles.dart';
import '../../../app_router.dart';
import 'toned_bottom_sheet.dart';

PreferredSizeWidget homeAppBar(BuildContext context, HomeProvider provider,
    {required bool withoutTabs}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: TextButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.selectedProgram.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey,
            )
          ],
        ),
      ),
      onPressed: () {
        // showProgramTray(context);
      },
    ),
    bottom: withoutTabs
        ? PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(),
          )
        : TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            labelStyle: tabHeadingBold,
            labelColor: Colors.black,
            unselectedLabelStyle: smallSubTitle,
            indicatorColor: Colors.transparent,
            tabs: provider.selectedProgram.exercisesList!
                .map((Exercise exercise) {
              return Tab(
                text: exercise.title,
              );
            }).toList(),
          ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamChannel(
                child: const StreamChatScreen(),
                channel:
                    Provider.of<AuthService>(context, listen: false).channel!,
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.help_outline,
          color: Colors.grey,
        ),
      ),
    ],
  );
}
