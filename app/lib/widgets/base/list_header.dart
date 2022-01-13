import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  final String title;

  const ListHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(title),
      visualDensity: VisualDensity.compact,
      textColor: theme.brightness == Brightness.light
          ? theme.primaryColor
          : Colors.white,
      tileColor: theme.dividerColor,
    );
  }
}
