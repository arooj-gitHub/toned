import 'package:flutter/material.dart';

class accountSettingTitle extends StatelessWidget {
  final String title;
  const accountSettingTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width,
       // color: Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3),
        ),
      ),
    );
  }
}
