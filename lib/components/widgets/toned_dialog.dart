import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

changePass(context) {
  showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          content: const Text(
            "Do you want to change password?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              child: const Text(
                "No",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      });
}
