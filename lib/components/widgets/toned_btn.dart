import 'package:flutter/material.dart';
import '/style/colors.dart';


class TextBtn extends StatelessWidget {

  final double width;
  final Color? color;
  final String title;
  final Function onTap;
  const TextBtn({Key? key, required this.width, this.color = primaryColor, required this.title, required this.onTap,  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextButton(onPressed: ()=>onTap(),style:  ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
      ),
          child:  Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),

      ),
    );
  }
}
