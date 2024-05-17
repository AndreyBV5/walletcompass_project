import 'package:flutter/material.dart';

class MyListTitle extends StatelessWidget {
  final String title;
  final String trailing;

  const MyListTitle({super.key, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Text(trailing),
    );
  }
}
