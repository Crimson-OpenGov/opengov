import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  final String title;

  const ListHeader(this.title);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(title),
        visualDensity: VisualDensity.compact,
        textColor: Theme.of(context).primaryColor,
        tileColor: Colors.grey.shade300,
      );
}
