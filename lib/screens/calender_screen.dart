import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '/components/item_event.dart';
import '/components/widgets/toned_illustration.dart';
import '/providers/auth_service.dart';
import '/providers/events_provider.dart';
import '/style/colors.dart';
import '/utils/constants.dart';
import 'chat/stream_schat_screen.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final provider = Provider.of<EventsProvider>(context, listen: false);
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      if (provider.eventsList.isEmpty) {
        provider.clearEventsList();
        provider.getEvents();
      }
    });
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        provider.getEvents();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<EventsProvider>(builder: (context, provider, wid) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Calendar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StreamChannel(
                      channel: Provider.of<AuthService>(context, listen: false)
                          .channel!,
                      child: const StreamChatScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.help_outline,
                color: Colors.blueGrey,
              ),
            ),
          ],
          // bottom: const PreferredSize(
          //   preferredSize: Size(1, 18),
          //   child: Text(
          //     "Weekly Overview",
          //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          //   ),
          // ),
        ),
        body: Column(
          children: [
            CalendarTimeline(
              initialDate: provider.selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2025, 11, 20),
              onDateSelected: (date) {
                provider.selectedDate = date;
                provider.clearEventsList();
                provider.getEvents();
              },
              leftMargin: 10,
              monthColor: Colors.blueGrey,
              dayColor: Colors.blueGrey,
              activeDayColor: Colors.black,
              activeBackgroundDayColor: primaryColor,
              dotsColor: Colors.black,
              locale: 'en_ISO',
              shrink: true,
            ),
            if (provider.eventsList.isNotEmpty) ...[
              Expanded(
                child: RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.eventsList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ItemEvent(index: index);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 0,
                        indent: 12,
                        endIndent: 12,
                      );
                    },
                  ),
                  onRefresh: () async {
                    provider.clearEventsList();
                    await provider.getEvents();
                  },
                ),
              ),
            ],
            if (provider.eventsList.isEmpty) ...[
              if (!provider.eventsLoading)
                const Expanded(
                  child: TonedIllustration(
                    text: 'No events for now',
                    asset: TonedAssets.meditation,
                  ),
                ),
            ],
            if (provider.eventsLoading)
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: const LinearProgressIndicator(),
              ),
          ],
        ),
      );
    });
  }
}
