import 'package:flutter/material.dart';

class TonedIllustration extends StatelessWidget {
  final String asset, text;
  const TonedIllustration({Key? key, required this.text, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: Image.asset(
            asset,
          ),
          height: 250,
          width: 250,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
