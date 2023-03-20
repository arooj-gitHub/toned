import 'package:flutter/material.dart';

class StreamChatScreen extends StatefulWidget {
  const StreamChatScreen({Key? key}) : super(key: key);

  @override
  _StreamChatScreenState createState() => _StreamChatScreenState();
}

class _StreamChatScreenState extends State<StreamChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: const ChannelHeader(
        //   title: Text('Toned Australia Support'),
        // ),
        // body: Column(
        //   children:  [
        //     Expanded(
        //       child: MessageListView(),
        //     ),
        //     MessageInput(),
        //   ],
        // ),
        );
  }
}
