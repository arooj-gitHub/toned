import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/components/widgets/home/toned_bottom_sheet.dart';
import '/components/widgets/chat_components/chat_bubble.dart';
import '/components/widgets/chat_components/image_chat_bubble.dart';
import '/components/widgets/chat_components/video_chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Thomas"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    ChatBubble(isSender: true, msg: 'Yo'),
                    ChatBubble(
                        isSender: true, msg: 'We have to assign new member.'),
                    ChatBubble(
                        isSender: false,
                        msg: 'People are asking me about the app?'),
                    ChatBubble(isSender: true, msg: 'I will send you.'),
                    ChatBubble(isSender: false, msg: 'Ok 💪💸'),
                    ChatBubble(
                        isSender: true,
                        msg: 'People are asking me about the app?'),
                    ChatBubble(isSender: true, msg: "What's up!"),
                    ImageChatBubble(isSender: false),
                    ChatBubble(
                        isSender: false,
                        msg: 'People are asking me about the app?'),
                    ChatBubble(isSender: true, msg: 'I will send you.'),
                    ChatBubble(isSender: false, msg: 'Ok 💪💸'),
                    ChatBubble(isSender: true, msg: 'Hi'),
                    ChatBubble(isSender: true, msg: "What's up!"),
                    ImageChatBubble(isSender: true),
                    ImageChatBubble(isSender: false),
                    VideoChatBubble(isSender: false),
                    ChatBubble(
                        isSender: false,
                        msg: 'People are asking me about the app?'),
                    ChatBubble(isSender: true, msg: 'I will send you.'),
                    ChatBubble(isSender: false, msg: 'Ok'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Row(
              children: [
                InkWell(
                  // onTap: () => chatTray(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .3,
                    ),
                    cursorColor: Theme.of(context).accentColor,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(18, 15, 10, 15),
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .5,
                      ),
                      labelStyle: const TextStyle(fontSize: 14),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.location_fill,
                            size: 22,
                            color: Colors.grey.shade700,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
