import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/components/ask_action.dart';
import '/models/event.dart';
import '/providers/events_provider.dart';
import '/providers/home_provider.dart';
import '/style/colors.dart';

class ItemEvent extends StatelessWidget {
  final int index;

  const ItemEvent({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _homeProvider = Provider.of<HomeProvider>(context);
    return Consumer<EventsProvider>(
      builder: (context, provider, widget) {
        EventModel event = provider.eventsList[index];
        String eventDateTimeDay = DateFormat.jm().format(event.eventDateTime!);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ListTile(
            title: Text(
              "${event.title}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$eventDateTimeDay",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Text(
                  "${event.description}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                askAction(
                  actionText: 'Yes',
                  cancelText: 'No',
                  text: _homeProvider.userEvents.contains(event.id) ? 'Remove ${event.title} from attending list?' : 'Do you want to attend ${event.title}?',
                  context: context,
                  func: () {
                    Navigator.pop(context);
                    if(_homeProvider.userEvents.contains(event.id)){
                      provider.neglectEvent(event);
                    } else{
                      provider.attendEvent(event);
                    }
                  },
                  cancelFunc: () => Navigator.pop(context),
                );
              },
              icon: _homeProvider.userEvents.contains(event.id)
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: successColor,
                    )
                  : const Icon(
                      Icons.check_circle_outlined,
                    ),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
