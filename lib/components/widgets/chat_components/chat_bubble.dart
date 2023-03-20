import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String msg;

  const ChatBubble({Key? key, required this.isSender, required this.msg})
      : super(key: key);

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  msg,
                  style: TextStyle(
                    color: isSender ? Colors.black : Colors.white,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '2:00 AM',
                      style: TextStyle(
                        color: isSender ? Colors.black : Colors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
