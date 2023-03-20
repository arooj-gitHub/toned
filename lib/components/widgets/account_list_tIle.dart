import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final Function onTap;

  const AccountListTile({Key? key, required this.title, required this.icon, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),),
      minLeadingWidth: 22,
      leading: icon,
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      onTap: () => onTap(),
    );
  }
}
