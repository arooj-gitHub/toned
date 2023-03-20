import 'package:flutter/material.dart';

Future askAction({
  required String actionText,
  required String cancelText,
  required String text,
  required BuildContext context,
  required Function func,
  required Function cancelFunc,
}) {
  Widget continueButton = MaterialButton(
    onPressed: () => func(),
    child: Text(actionText),
  );
  Widget cancelButton = MaterialButton(
    onPressed: () => cancelFunc(),
    child: Text(cancelText),
  );
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      elevation: 30,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      actions: <Widget>[cancelButton, continueButton],
    ),
  );
}
