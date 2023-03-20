import 'package:flutter/material.dart';

class MediaListItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function func;

  const MediaListItem({Key? key, required this.iconData, required this.title, required this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: Icon(iconData, color: Colors.black,),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
      onTap: () => func(),
    );
  }
}
