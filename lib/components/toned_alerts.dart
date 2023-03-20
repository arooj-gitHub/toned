import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/components/widgets/chat_components/media_list.dart';
import '/services/navigation_service.dart';

import '../locator.dart';

class TonedAlerts {
  final NavigationService _navigationService = locator<NavigationService>();

  showLoading(BuildContext context, {String? title}) {
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Text(
                    title ?? 'Loading...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Theme.of(context).textTheme.displayLarge!.color,
                    ),
                  ),
                ),
                const LinearProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  showMessage(
    BuildContext context, {
    String? title,
    String? subTitle,
    IconData? iconData,
    bool isDismissible = false,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) ...[
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (subTitle != null) ...[
                        Text(subTitle),
                      ],
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 20,
                    ),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      onPressed: hide,
                      child: Text(
                        'OK',
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .color),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ask(BuildContext context,
      {String? yesText,
      String? noText,
      required String title,
      bool isDismissible = false,
      bool isComplexText = false,
      Widget? complexText,
      required Function func,
      required Function cancelFunc}) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      isScrollControlled: isDismissible,
      enableDrag: isDismissible,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            if (isDismissible) Navigator.pop(context);
            return false;
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  child: isComplexText
                      ? complexText
                      : Text(
                          title,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                            fontSize: 16,
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 20,
                      left: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            onPressed: () => cancelFunc(),
                            child: Text(
                              noText ?? 'No',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            onPressed: () => func(),
                            child: Text(
                              yesText ?? 'Yes',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .color),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  hide() {
    _navigationService.goBack();
  }
}

showMediaBottomSheet(context) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Media',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MediaListItem(
                    iconData: Icons.camera_alt_rounded,
                    title: 'Camera',
                    func: () {}),
                MediaListItem(
                    iconData: Icons.perm_media_rounded,
                    title: 'Gallery',
                    func: () {}),
                MediaListItem(
                    iconData: Icons.insert_drive_file_rounded,
                    title: 'File',
                    func: () {}),
                MediaListItem(
                    iconData: CupertinoIcons.money_dollar_circle_fill,
                    title: 'Offer',
                    func: () {}),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}
